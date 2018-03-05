# frozen_string_literal: true

class CreateGlobalsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :globals do |t|
    end
  end
end
