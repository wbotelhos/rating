# frozen_string_literal: true

module Rating
  class Rating < ActiveRecord::Base
    self.table_name = 'rating_ratings'

    belongs_to :resource , polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :average, :estimate, :resource, :sum, :total, presence: true
    validates :average, :estimate, :sum, :total, numericality: true

    class << self
      def averager_data(resource, scopeable)
        total_count    = how_many_resource_received_votes_sql?(distinct: false, scopeable: scopeable)
        distinct_count = how_many_resource_received_votes_sql?(distinct: true , scopeable: scopeable)
        values         = { resource_type: resource.class.base_class.name }

        values[:scopeable_type] = scopeable.class.base_class.name unless scopeable.nil?

        sql = %(
          SELECT
            (#{total_count} / CAST(#{distinct_count} AS float)) count_avg,
            COALESCE(AVG(value), 0)                             rating_avg
          FROM #{rate_table_name}
          WHERE resource_type = :resource_type AND #{scope_type_query(scopeable)}
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
          total:    values.rating_count
        }
      end

      def values_data(resource, scopeable)
        scope_query = if scopeable.nil?
                        'scopeable_type is NULL AND scopeable_id is NULL'
                      else
                        'scopeable_type = ? AND scopeable_id = ?'
                      end

        sql = %(
          SELECT
            COALESCE(AVG(value), 0) rating_avg,
            COALESCE(SUM(value), 0) rating_sum,
            COUNT(1)                rating_count
          FROM #{rate_table_name}
          WHERE resource_type = ? AND resource_id = ? AND #{scope_query}
        ).squish

        values =  [sql, resource.class.base_class.name, resource.id]
        values += [scopeable.class.base_class.name, scopeable.id] unless scopeable.nil?

        execute_sql values
      end

      def update_rating(resource, scopeable)
        record = find_or_initialize_by(resource: resource, scopeable: scopeable)
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

      def how_many_resource_received_votes_sql?(distinct:, scopeable:)
        count = distinct ? 'COUNT(DISTINCT resource_id)' : 'COUNT(1)'

        %((
          SELECT #{count}
          FROM #{rate_table_name}
          WHERE resource_type = :resource_type AND #{scope_type_query(scopeable)}
        ))
      end

      def rate_table_name
        @rate_table_name ||= Rate.table_name
      end

      def scope_type_query(scopeable)
        scopeable.nil? ? 'scopeable_type is NULL' : 'scopeable_type = :scopeable_type'
      end
    end
  end
end
