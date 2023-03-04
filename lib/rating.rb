# frozen_string_literal: true

module Rating
end

require 'rating/config'
require 'rating/models/rating/extension'
require 'rating/models/rating/rate'
require 'rating/models/rating/rating'

ActiveSupport.on_load(:active_record) { include Rating::Extension }
