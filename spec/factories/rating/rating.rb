# frozen_string_literal: true

FactoryBot.define do
  factory :rating_rating, class: Rating::Rating do
    average  { 100 }
    estimate { 100 }
    sum      { 100 }
    total    { 1 }

    association :resource, factory: :article, strategy: :build
  end
end
