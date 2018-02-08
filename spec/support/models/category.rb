# frozen_string_literal: true

class Category < ::ActiveRecord::Base
  belongs_to :article
end
