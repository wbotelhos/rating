# frozen_string_literal: true

class AddExtraScopesOnRatingRatesTable < ActiveRecord::Migration[5.0]
  def change
    add_column :rating_rates, :scope_1, :string
    add_column :rating_rates, :scope_2, :string

    remove_index :rating_rates, %i[author_id author_type resource_id resource_type scopeable_id scopeable_type]
  end
end
