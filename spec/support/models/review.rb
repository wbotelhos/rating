# frozen_string_literal: true

class Review < ::ActiveRecord::Base
  belongs_to :scopeable, polymorphic: true
end
