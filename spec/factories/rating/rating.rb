# frozen_string_literal: true

FactoryBot.define do
  factory :rating_rating, class: 'Rating::Rating' do
    average { 5 }
    estimate { 5 }
    sum { 5 }
    total { 1 }

    resource { FactoryBot.build(:article) }
  end
end
