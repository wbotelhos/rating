# frozen_string_literal: true

class Review < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  belongs_to :scopeable, polymorphic: true
end
