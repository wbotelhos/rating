# frozen_string_literal: true

class Toy < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  rating where: 'value > 1 and value < 5'
end
