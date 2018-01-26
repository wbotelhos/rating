# frozen_string_literal: true

class AddCommentOnRatingRatesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :rating_rates, :comment, :text
  end
end
