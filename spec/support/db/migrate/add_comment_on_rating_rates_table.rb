# frozen_string_literal: true

class AddCommentOnRatingRatesTable < ActiveRecord::Migration[7.0]
  def change
    add_column :rating_rates, :comment, :text
    add_column :reviews,      :comment, :text
  end
end
