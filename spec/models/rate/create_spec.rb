# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rate, ':create' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  before { create :rating_rate, author: user, resource: article, value: 3 }

  context 'when rate does not exist yet' do
    it 'creates a rate entry' do
      rate = described_class.last

      expect(rate.author).to   eq user
      expect(rate.resource).to eq article
      expect(rate.value).to    eq 3
    end

    it 'creates a rating entry' do
      rating = Rating::Rating.last

      expect(rating.average).to  eq 3
      expect(rating.estimate).to eq 3
      expect(rating.resource).to eq article
      expect(rating.sum).to      eq 3
      expect(rating.total).to    eq 1
    end
  end

  context 'when rate already exists' do
    let!(:user_2) { create :user }

    before { create :rating_rate, author: user_2, resource: article, value: 4 }

    it 'creates one more rate entry' do
      rates = described_class.where(author: [user, user_2]).order('created_at asc')

      expect(rates.size).to eq 2

      rate = rates[0]

      expect(rate.author).to   eq user
      expect(rate.resource).to eq article
      expect(rate.value).to    eq 3

      rate = rates[1]

      expect(rate.author).to   eq user_2
      expect(rate.resource).to eq article
      expect(rate.value).to    eq 4
    end

    it 'updates the unique rating entry' do
      rating = Rating::Rating.find_by(resource: article)

      expect(rating.average).to  eq 3.5
      expect(rating.estimate).to eq 3.5
      expect(rating.resource).to eq article
      expect(rating.sum).to      eq 7
      expect(rating.total).to    eq 2
    end
  end
end
