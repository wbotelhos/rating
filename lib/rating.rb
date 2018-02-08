# frozen_string_literal: true

module Rating
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end
end

require 'rating/config'
require 'rating/models/rating/extension'
require 'rating/models/rating/rate'
require 'rating/models/rating/rating'

ActiveRecord::Base.include Rating::Extension
