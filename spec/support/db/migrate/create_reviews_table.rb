# frozen_string_literal: true

class CreateReviewsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.decimal :value, default: 0, precision: 25, scale: 16

      t.references :author,    index: true, null: false, polymorphic: true
      t.references :resource,  index: true, null: false, polymorphic: true
      t.references :scopeable, index: true, null: true,  polymorphic: true

      t.timestamps
    end
  end
end
