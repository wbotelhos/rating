# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, 'unscoped_rating' do
  let!(:author_1) { create :author }
  let!(:author_2) { create :author }
  let!(:author_3) { create :author }
  let!(:author_4) { create :author }
  let!(:author_5) { create :author }
  let!(:resource) { create :toy }

  it 'uses rate with where condition' do
    author_1.rate resource, 1
    author_2.rate resource, 2
    author_3.rate resource, 3
    author_4.rate resource, 4
    author_5.rate resource, 5

    ratings = Rating::Rating.all.order('id')

    expect(ratings.size).to eq 1

    rating = ratings[0]

    expect(rating.average.to_s).to  eq '3.0'
    expect(rating.estimate.to_s).to eq '3.0'
    expect(rating.resource).to      eq resource
    expect(rating.scopeable).to     eq nil
    expect(rating.sum).to           eq 9
    expect(rating.total).to         eq 3
  end
end
