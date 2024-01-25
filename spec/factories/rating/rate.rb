# frozen_string_literal: true

FactoryBot.define do
  factory :rating_rate, class: 'Rating::Rate' do
    value { 100 }

    author { FactoryBot.build(:author) }
    resource { FactoryBot.build(:article) }
  end
end
