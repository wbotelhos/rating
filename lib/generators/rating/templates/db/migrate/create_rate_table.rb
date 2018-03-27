# frozen_string_literal: true

class CreateRateTable < ActiveRecord::Migration[5.0]
  def change
    create_table :rating_rates do |t|
      t.decimal :value, default: 0, precision: 25, scale: 16

      t.references :author,    index: true, null: false, polymorphic: true
      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps null: false
    end

    change_column :rating_rates, :author_type,    :string, limit: 10
    change_column :rating_rates, :resource_type,  :string, limit: 10
    change_column :rating_rates, :scopeable_type, :string, limit: 10

    add_index :rating_rates, %i[author_type author_id resource_type resource_id scopeable_type scopeable_id],
      name:   :index_rating_rates_on_author_and_resource_and_scopeable,
      unique: true
  end
end
