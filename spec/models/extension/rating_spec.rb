# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, '.rating' do
  let!(:category) { create :category }

  let!(:user_1) { create :user }
  let!(:user_2) { create :user }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  let!(:rate_1) { create :rating_rate, author: user_1, resource: article_1, value: 100 }
  let!(:rate_2) { create :rating_rate, author: user_1, resource: article_2, value: 11 }
  let!(:rate_3) { create :rating_rate, author: user_1, resource: article_3, value: 10 }
  let!(:rate_4) { create :rating_rate, author: user_2, resource: article_1, value: 1 }

  let!(:rate_5) { create :rating_rate, author: user_1, resource: article_1, scopeable: category, value: 1 }
  let!(:rate_6) { create :rating_rate, author: user_2, resource: article_1, scopeable: category, value: 2 }

  context 'with no scope' do
    it 'returns rating record' do
      expect(article_1.rating).to eq Rating::Rating.find_by(resource: article_1, scopeable: nil)
    end
  end

  context 'with scope' do
    it 'returns scoped rating record' do
      expect(article_1.rating(scope: category)).to eq Rating::Rating.find_by(resource: article_1, scopeable: category)
    end
  end

  context 'when destroy author' do
    it 'does not destroy resource rating' do
      expect(Rating::Rating.where(resource: article_1).count).to eq 2

      user_1.destroy!

      expect(Rating::Rating.where(resource: article_1).count).to eq 2
    end
  end

  context 'when destroy resource' do
    it 'destroys resource rating too' do
      expect(Rating::Rating.where(resource: article_1).count).to eq 2

      article_1.destroy!

      expect(Rating::Rating.where(resource: article_1).count).to eq 0
    end
  end
end
