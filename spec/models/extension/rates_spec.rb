# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rates' do
  let!(:category) { create :category }

  let!(:author_1) { create :author }
  let!(:author_2) { create :author }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  let!(:rate_1) { create :rating_rate, author: author_1, resource: article_1, value: 100 }
  let!(:rate_2) { create :rating_rate, author: author_1, resource: article_2, value: 11 }
  let!(:rate_3) { create :rating_rate, author: author_1, resource: article_3, value: 10 }
  let!(:rate_4) { create :rating_rate, author: author_2, resource: article_1, value: 1 }

  let!(:rate_5) { create :rating_rate, author: author_1, resource: article_1, scopeable: category, value: 1 }
  let!(:rate_6) { create :rating_rate, author: author_2, resource: article_1, scopeable: category, value: 2 }

  context 'with no scope' do
    it 'returns rates that this resource received' do
      expect(article_1.rates).to match_array [rate_1, rate_4]
    end
  end

  context 'with scope' do
    it 'returns scoped rates that this resource received' do
      expect(article_1.rates(scope: category)).to match_array [rate_5, rate_6]
    end
  end

  context 'when destroy author' do
    it 'destroys rates of that author' do
      expect(Rating::Rate.where(author: author_1).count).to eq 4

      author_1.destroy!

      expect(Rating::Rate.where(author: author_1).count).to eq 0
    end
  end

  context 'when destroy resource' do
    it 'destroys rates of that resource' do
      expect(Rating::Rate.where(resource: article_1).count).to eq 4

      article_1.destroy!

      expect(Rating::Rate.where(resource: article_1).count).to eq 0
    end
  end
end
