# frozen_string_literal: true

class Category < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  belongs_to :article
  belongs_to :global
end
