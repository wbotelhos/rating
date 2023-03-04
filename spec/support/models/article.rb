# frozen_string_literal: true

class Article < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  rating scoping: :categories

  has_many :categories
end
