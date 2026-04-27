# frozen_string_literal: true

module Rating
  class Rating < ActiveRecord::Base
    self.table_name_prefix = 'rating_'
    self.table_name        = ::Rating::Config.rating_table

    belongs_to :resource,  polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :average, :estimate, :sum, :total, presence: true
    validates :average, :estimate, :sum, :total, numericality: true

    validates :resource_id, uniqueness: {
      case_sensitive: false,
      scope:          %i[resource_type scopeable_id scopeable_type],
    }

    class << self
      def histogram_data(resource, scopeable)
        sql = %(
          SELECT
            value,
            COUNT(1) AS rating_count
          FROM #{rate_table_name}
          WHERE
            resource_type = ?
            AND resource_id = ?
            #{scope_type_and_id_query(resource, scopeable)}
            #{scope_where_query(resource)}
          GROUP BY value
        ).squish

        values =  [sql, resource.class.base_class.name, resource.id]
        values += [scopeable.class.base_class.name, scopeable.id] unless scopeable.nil? || unscoped_rating?(resource)

        Rate.find_by_sql(values).to_h do |row|
          [row.value.to_i, row.rating_count.to_i]
        end
      end

      def data(resource, scopeable)
        histogram = histogram_data(resource, scopeable)
        values    = values_data(resource, scopeable)

        {
          average:  values.rating_avg,
          estimate: miller_lower_bound(histogram),
          sum:      values.rating_sum,
          total:    values.rating_count,
        }
      end

      def values_data(resource, scopeable)
        sql = %(
          SELECT
            COALESCE(AVG(value), 0) rating_avg,
            COALESCE(SUM(value), 0) rating_sum,
            COUNT(1)                rating_count
          FROM #{rate_table_name}
          WHERE
            resource_type = ?
            AND resource_id = ?
            #{scope_type_and_id_query(resource, scopeable)}
            #{scope_where_query(resource)}
        ).squish

        values =  [sql, resource.class.base_class.name, resource.id]
        values += [scopeable.class.base_class.name, scopeable.id] unless scopeable.nil? || unscoped_rating?(resource)

        execute_sql values
      end

      def update_rating(resource, scopeable)
        attributes             = { resource: }
        attributes[:scopeable] = unscoped_rating?(resource) ? nil : scopeable

        record = find_or_initialize_by(attributes)
        result = data(resource, scopeable)

        record.average  = result[:average]
        record.sum      = result[:sum]
        record.total    = result[:total]
        record.estimate = result[:estimate]

        record.save
      end

      private

      def miller_lower_bound(histogram)
        rating_levels = ::Rating::Config.rating_levels
        z_score = ::Rating::Config.rating_z_score
        total_votes = (1..rating_levels).sum { |level| histogram.fetch(level, 0) }

        return BigDecimal('0') if total_votes.zero?

        denominator = total_votes + rating_levels

        smoothed_mean = (1..rating_levels).sum do |level|
          level * (histogram.fetch(level, 0) + 1).to_d / denominator
        end

        smoothed_variance = (1..rating_levels).sum do |level|
          (level**2) * (histogram.fetch(level, 0) + 1).to_d / denominator
        end - (smoothed_mean**2)

        smoothed_mean - (z_score.to_d * (smoothed_variance / (denominator + 1)).sqrt(16))
      end

      def execute_sql(sql)
        Rate.find_by_sql(sql).first
      end

      def unscoped_rating?(resource)
        resource.rating_options[:unscoped_rating]
      end

      def rate_table_name
        @rate_table_name ||= Rate.table_name
      end

      def scope_type_and_id_query(resource, scopeable)
        return '' if unscoped_rating?(resource)
        return 'AND scopeable_type is NULL AND scopeable_id is NULL' if scopeable.nil?

        'AND scopeable_type = ? AND scopeable_id = ?'
      end

      def scope_where_query(resource)
        return '' if where_condition(resource).blank?

        "AND #{where_condition(resource)}"
      end

      def where_condition(resource)
        resource.rating_options[:where]
      end
    end
  end
end
