# frozen_string_literal: true

class AddExtraScopesOnRatingRatesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :rating_rates, :scope_1, :string
    add_column :rating_rates, :scope_2, :string
  end
end
