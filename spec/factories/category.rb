# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |i| "Category #{i}" }
  end
end
