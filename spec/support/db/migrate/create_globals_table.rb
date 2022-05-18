# frozen_string_literal: true

class CreateGlobalsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :globals do |t|
    end
  end
end
