# frozen_string_literal: true

module Rating
  module Extension
    extend ActiveSupport::Concern

    included do
      def rate(resource, value, author: self)
        Rate.create author: author, resource: resource, value: value
      end

      def rate_for(resource)
        Rate.rate_for author: self, resource: resource
      end

      def rated?(resource)
        !rate_for(resource).nil?
      end
    end

    module ClassMethods
      def rating
        after_create { Rating.find_or_create_by resource: self }

        has_one :rating,
          as:         :resource,
          class_name: '::Rating::Rating',
          dependent:  :destroy

        has_many :rates,
          as:         :resource,
          class_name: '::Rating::Rate',
          dependent:  :destroy

        has_many :rated,
          as:         :author,
          class_name: '::Rating::Rate',
          dependent:  :destroy

        scope :order_by_rating, ->(column = :estimate, direction = :desc) {
          includes(:rating).order("#{Rating.table_name}.#{column} #{direction}")
        }
      end
    end
  end
end
