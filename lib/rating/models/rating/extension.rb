# frozen_string_literal: true

module Rating
  module Extension
    extend ActiveSupport::Concern

    included do
      def rate(resource, value, author: self, extra_scopes: {}, metadata: {}, scope: nil)
        Rate.create(
          author:       author,
          extra_scopes: extra_scopes,
          metadata:     metadata,
          resource:     resource,
          scopeable:    scope,
          value:        value
        )
      end

      def rate_for(resource, extra_scopes: {}, scope: nil)
        Rate.rate_for author: self, extra_scopes: extra_scopes, resource: resource, scopeable: scope
      end

      # TODO: use exists for performance
      def rated?(resource, extra_scopes: {}, scope: nil)
        !rate_for(resource, extra_scopes: extra_scopes, scope: scope).nil?
      end

      def rates(extra_scopes: {}, scope: nil)
        attributes = { scopeable: scope }.merge(extra_scopes)

        rates_records.where attributes
      end

      def rated(extra_scopes: {}, scope: nil)
        attributes = { scopeable: scope }.merge(extra_scopes)

        rated_records.where attributes
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
      def rating(options = {})
        after_create -> { rating_warm_up scoping: options[:scoping] }, unless: -> { options[:as] == :author }

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

        scope :order_by_rating, lambda { |column = :estimate, direction = :desc, scope: nil|
          includes(:rating_records)
            .where(Rating.table_name => { scopeable_id: scope&.id, scopeable_type: scope&.class&.base_class&.name })
            .order("#{Rating.table_name}.#{column} #{direction}")
        }

        define_method :rating_options do
          options
        end
      end
    end
  end
end
