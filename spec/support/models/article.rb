# frozen_string_literal: true

class Article < ::ActiveRecord::Base
  rating scoping: :categories

  has_many :categories
end
