# frozen_string_literal: true

class Author < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  rating as: :author
end
