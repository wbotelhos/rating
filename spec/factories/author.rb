# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    sequence(:name) { |i| "Author #{i}" }
  end
end
