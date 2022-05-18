# frozen_string_literal: true

class CreateCommentsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :comments
  end
end
