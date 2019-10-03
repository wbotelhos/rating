# frozen_string_literal: true

FactoryBot.define do
  factory :rating_rate, class: Rating::Rate do
    value { 100 }

    author   { create :author }
    resource { create :article }
  end
end
