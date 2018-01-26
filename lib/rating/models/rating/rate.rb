# frozen_string_literal: true

module Rating
  class Rate < ActiveRecord::Base
    self.table_name = 'rating_rates'

    after_save :update_rating

    belongs_to :author,    polymorphic: true
    belongs_to :resource,  polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :author, :resource, :value, presence: true
    validates :value, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }

    validates :author_id, uniqueness: {
      case_sensitive: false,
      scope:          %i[author_type resource_id resource_type scopeable_id scopeable_type]
    }

    def self.create(author:, metadata:, resource:, scopeable: nil, value:)
      record = find_or_initialize_by(author: author, resource: resource, scopeable: scopeable)

      return record if record.persisted? && value == record.value

      metadata.each { |k, v| record[k] = v } if metadata.present?

      record.value = value
      record.save

      record
    end

    def self.rate_for(author:, resource:, scopeable: nil)
      find_by author: author, resource: resource, scopeable: scopeable
    end

    private

    def update_rating
      ::Rating::Rating.update_rating resource, scopeable
    end
  end
end
