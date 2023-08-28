# frozen_string_literal: true

FactoryBot.define do
  factory :rating_rate, class: 'Rating::Rate' do
    value { 100 }

    author
    resource
  end
end
