# frozen_string_literal: true

class CreateRatingTable < ActiveRecord::Migration[5.0]
  def change
    create_table :rating_ratings do |t|
      t.decimal :average,  default: 0, mull: false, precision: 25, scale: 16
      t.decimal :estimate, default: 0, mull: false, precision: 25, scale: 16
      t.integer :sum,      default: 0, mull: false
      t.integer :total,    default: 0, mull: false

      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps null: false
    end

    change_column :rating_ratings, :resource_type,  :string, limit: 10
    change_column :rating_ratings, :scopeable_type, :string, limit: 10

    add_index :rating_ratings, %i[resource_type resource_id scopeable_type scopeable_id],
      name:   :index_rating_rating_on_resource_and_scopeable,
      unique: true
  end
end
