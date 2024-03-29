# frozen_string_literal: true

class CreateRatingTable < ActiveRecord::Migration[7.0]
  def change
    create_table :rating_ratings do |t|
      t.decimal :average,  default: 0, mull: false, precision: 25, scale: 16
      t.decimal :estimate, default: 0, mull: false, precision: 25, scale: 16
      t.bigint  :sum,      default: 0, mull: false
      t.bigint  :total,    default: 0, mull: false

      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps
    end

    change_column :rating_ratings, :resource_type,  :string, limit: 10
    change_column :rating_ratings, :scopeable_type, :string, limit: 10
  end
end
