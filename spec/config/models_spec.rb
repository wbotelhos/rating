# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Config, '.models' do
  it 'changes the rating models' do
    subject.models rate: Review, rating: ReviewRating

    expect(subject.rate_model).to   eq Review
    expect(subject.rating_model).to eq ReviewRating
  end
end
