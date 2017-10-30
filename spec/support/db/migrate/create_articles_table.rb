# frozen_string_literal: true

class CreateArticlesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :name, null: false
    end
  end
end
