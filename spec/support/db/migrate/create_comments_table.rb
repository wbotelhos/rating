# frozen_string_literal: true

class CreateCommentsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :comments
  end
end
