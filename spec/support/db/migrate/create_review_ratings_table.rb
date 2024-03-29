# frozen_string_literal: true

class CreateReviewRatingsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :review_ratings do |t|
      t.decimal :average,  default: 0, mull: false, precision: 25, scale: 16
      t.decimal :estimate, default: 0, mull: false, precision: 25, scale: 16
      t.bigint  :sum,      default: 0, mull: false
      t.bigint  :total,    default: 0, mull: false

      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps
    end
  end
end
