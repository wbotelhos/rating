# frozen_string_literal: true

module Rating
  module Extension
    extend ActiveSupport::Concern

    included do
      def rate(resource, value, author: self, metadata: {}, scope: nil)
        Rate.create author: author, metadata: metadata, resource: resource, scopeable: scope, value: value
      end

      def rate_for(resource, scope: nil)
        Rate.rate_for author: self, resource: resource, scopeable: scope
      end

      def rated?(resource, scope: nil)
        !rate_for(resource, scope: scope).nil?
      end

      def rates(scope: nil)
        rates_records.where scopeable: scope
      end

      def rated(scope: nil)
        rated_records.where scopeable: scope
      end

      def rating(scope: nil)
        rating_records.find_by scopeable: scope
      end

      def rating_warm_up(scoping: nil)
        return Rating.find_or_create_by(resource: self) if scoping.blank?

        [scoping].flatten.compact.map do |attribute|
          next unless respond_to?(attribute)

          [public_send(attribute)].flatten.compact.map do |object|
            Rating.find_or_create_by! resource: self, scopeable: object
          end
        end.flatten.compact
      end
    end

    module ClassMethods
      def rating(as: nil, scoping: nil)
        after_save -> { rating_warm_up scoping: scoping }, unless: -> { as == :author }

        has_many :rating_records,
          as:         :resource,
          class_name: '::Rating::Rating',
          dependent:  :destroy

        has_many :rates_records,
          as:         :resource,
          class_name: '::Rating::Rate',
          dependent:  :destroy

        has_many :rated_records,
          as:         :author,
          class_name: '::Rating::Rate',
          dependent:  :destroy

        scope :order_by_rating, ->(column = :estimate, direction = :desc, scope: nil) {
          scope_values = {
            scopeable_id:   scope&.id,
            scopeable_type: scope&.class&.base_class&.name
          }

          includes(:rating_records)
            .where(Rating.table_name => scope_values)
            .order("#{Rating.table_name}.#{column} #{direction}")
        }
      end
    end
  end
end
