# frozen_string_literal: true

module Rating
  class Rating < ActiveRecord::Base
    self.table_name_prefix = 'rating_'
    self.table_name        = ::Rating::Config.rating_table

    belongs_to :resource,  polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :average, :estimate, :resource, :sum, :total, presence: true
    validates :average, :estimate, :sum, :total, numericality: true

    validates :resource_id, uniqueness: {
      case_sensitive: false,
      scope:          %i[resource_type scopeable_id scopeable_type],
    }

    class << self
      def averager_data(resource, scopeable)
        total_count    = how_many_resource_received_votes_sql(distinct: false, resource: resource, scopeable: scopeable)
        distinct_count = how_many_resource_received_votes_sql(distinct: true, resource: resource, scopeable: scopeable)
        values         = { resource_type: resource.class.base_class.name }

        values[:scopeable_type] = scopeable.class.base_class.name unless scopeable.nil?

        sql = %(
          SELECT
            (CAST(#{total_count} AS DECIMAL(17, 14)) / #{distinct_count}) count_avg,
            COALESCE(AVG(value), 0)                                       rating_avg
          FROM #{rate_table_name}
          WHERE
            resource_type = :resource_type
            #{scope_type_query(resource, scopeable)}
            #{scope_where_query(resource)}
        ).squish

        execute_sql [sql, values]
      end

      def data(resource, scopeable)
        averager = averager_data(resource, scopeable)
        values   = values_data(resource, scopeable)

        {
          average:  values.rating_avg,
          estimate: estimate(averager, values),
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
        attributes             = { resource: resource }
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

      def estimate(averager, values)
        resource_type_rating_avg = averager.rating_avg
        count_avg                = averager.count_avg
        resource_rating_avg      = values.rating_avg
        resource_rating_count    = values.rating_count.to_f

        (resource_rating_count / (resource_rating_count + count_avg)) * resource_rating_avg +
          (count_avg           / (resource_rating_count + count_avg)) * resource_type_rating_avg
      end

      def execute_sql(sql)
        Rate.find_by_sql(sql).first
      end

      def unscoped_rating?(resource)
        resource.rating_options[:unscoped_rating]
      end

      def how_many_resource_received_votes_sql(distinct:, resource:, scopeable:)
        count = distinct ? 'COUNT(DISTINCT resource_id)' : 'COUNT(1)'

        %((
          SELECT GREATEST(#{count}, 1)
          FROM #{rate_table_name}
          WHERE
            resource_type = :resource_type
            #{scope_type_query(resource, scopeable)}
            #{scope_where_query(resource)}
        ))
      end

      def rate_table_name
        @rate_table_name ||= Rate.table_name
      end

      def scope_type_query(resource, scopeable)
        return '' if unscoped_rating?(resource)

        scopeable.nil? ? 'AND scopeable_type is NULL' : 'AND scopeable_type = :scopeable_type'
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
