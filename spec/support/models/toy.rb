# frozen_string_literal: true

class Toy < ::ActiveRecord::Base
  rating where: 'value > 1 and value < 5'
end
