# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "User #{i}" }
  end
end
