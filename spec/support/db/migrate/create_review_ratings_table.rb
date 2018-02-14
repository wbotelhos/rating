# frozen_string_literal: true

class CreateReviewRatingsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :review_ratings do |t|
      t.decimal :average,  default: 0, mull: false, precision: 25, scale: 16
      t.decimal :estimate, default: 0, mull: false, precision: 25, scale: 16
      t.integer :sum,      default: 0, mull: false
      t.integer :total,    default: 0, mull: false

      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps null: false
    end
  end
end
