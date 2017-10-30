# frozen_string_literal: true

module Rating
  class Rate < ActiveRecord::Base
    self.table_name = 'rating_rates'

    after_save :update_rating

    belongs_to :author  , polymorphic: true
    belongs_to :resource, polymorphic: true

    validates :author, :resource, :value, presence: true
    validates :value, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }

    validates :author_id, uniqueness: {
      case_sensitive: false,
      scope:          %i[author_type resource_id resource_type]
    }

    def self.create(author:, resource:, value:)
      record = find_or_initialize_by(author: author, resource: resource)

      return record if record.persisted? && value == record.value

      record.value = value
      record.save

      record
    end

    def self.rate_for(author:, resource:)
      find_by author: author, resource: resource
    end

    private

    def update_rating
      ::Rating::Rating.update_rating resource
    end
  end
end
