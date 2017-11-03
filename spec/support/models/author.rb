# frozen_string_literal: true

class Author < ::ActiveRecord::Base
  rating as: :author
end
