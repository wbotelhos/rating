# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "Name #{i}" }
  end
end
