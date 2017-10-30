# frozen_string_literal: true

module Rating
  class Rating < ActiveRecord::Base
    self.table_name = 'rating_ratings'

    belongs_to :resource, polymorphic: true

    validates :average, :estimate, :resource, :sum, :total, presence: true
    validates :average, :estimate, :sum, :total, numericality: true

    class << self
      def averager_data(resource)
        total_count    = how_many_resource_received_votes_sql?
        distinct_count = how_many_resource_received_votes_sql?(distinct: true)

        sql = %(
          SELECT
            (#{total_count} / CAST(#{distinct_count} AS float)) count_avg,
            COALESCE(AVG(value), 0)                             rating_avg
          FROM #{rate_table_name}
          WHERE resource_type = :resource_type
        ).squish

        execute_sql [sql, resource_type: resource.class.base_class.name]
      end

      def data(resource)
        averager = averager_data(resource)
        values   = values_data(resource)

        {
          average:  values.rating_avg,
          estimate: estimate(averager, values),
          sum:      values.rating_sum,
          total:    values.rating_count
        }
      end

      def values_data(resource)
        sql = %(
          SELECT
            COALESCE(AVG(value), 0) rating_avg,
            COALESCE(SUM(value), 0) rating_sum,
            COUNT(1)                rating_count
          FROM #{rate_table_name}
          WHERE resource_type = ? and resource_id = ?
        ).squish

        execute_sql [sql, resource.class.base_class.name, resource.id]
      end

      def update_rating(resource)
        record = find_or_initialize_by(resource: resource)
        result = data(resource)

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

      def how_many_resource_received_votes_sql?(distinct: false)
        count = distinct ? 'COUNT(DISTINCT resource_id)' : 'COUNT(1)'

        %((
          SELECT #{count}
          FROM #{rate_table_name}
          WHERE resource_type = :resource_type
        ))
      end

      def rate_table_name
        @rate_table_name ||= Rate.table_name
      end
    end
  end
end
