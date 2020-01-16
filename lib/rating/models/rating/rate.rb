# frozen_string_literal: true

module Rating
  class Rate < ActiveRecord::Base
    self.table_name_prefix = 'rating_'
    self.table_name        = ::Rating::Config.rate_table

    after_save :update_rating

    belongs_to :author,    polymorphic: true
    belongs_to :resource,  polymorphic: true
    belongs_to :scopeable, polymorphic: true

    validates :author, :resource, :value, presence: true
    validates :value, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }

    validates :author_id, uniqueness: {
      case_sensitive: ::Rating::Config.validations['rate']['case_sensitive'],
      scope:          ::Rating::Config.validations['rate']['scope'].map(&:to_sym),
    }

    def self.create(author:, extra_scopes:, metadata:, resource:, scopeable: nil, value:)
      attributes = { author: author, resource: resource, scopeable: scopeable }.merge(extra_scopes)
      record     = find_or_initialize_by(attributes)

      metadata.each { |k, v| record[k] = v } if metadata.present?

      record.value = value
      record.save

      record
    end

    def self.rate_for(author:, extra_scopes: {}, resource:, scopeable: nil)
      find_by extra_scopes.merge(author: author, resource: resource, scopeable: scopeable)
    end

    private

    def update_rating
      ::Rating::Rating.update_rating resource, scopeable
    end
  end
end
