# frozen_string_literal: true

class CreateAuthorsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
    end
  end
end
