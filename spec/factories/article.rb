# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    sequence(:name) { |i| "Article #{i}" }
  end
end
