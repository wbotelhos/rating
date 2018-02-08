# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Config, '.configure' do
  before do
    Rating.configure do |config|
      config.models rate: 'Review', rating: 'ReviewRating'
    end
  end

  let!(:author)   { create :author }
  let!(:resource) { create :article }

  xit 'changes the rating models' do
    author.rate resource, 5

    expect(Review.count).to       eq 1
    expect(ReviewRating.count).to eq 1
  end
end
