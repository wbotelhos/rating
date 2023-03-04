# frozen_string_literal: true

class Global < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  rating scoping: :categories, unscoped_rating: true

  has_many :categories
end
