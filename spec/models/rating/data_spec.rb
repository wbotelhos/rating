# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rating, ':data' do
  let!(:category) { create :category }

  let!(:user_1) { create :user }
  let!(:user_2) { create :user }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  before do
    create :rating_rate, author: user_1, resource: article_1, value: 100
    create :rating_rate, author: user_1, resource: article_2, value: 11
    create :rating_rate, author: user_1, resource: article_3, value: 10
    create :rating_rate, author: user_2, resource: article_1, value: 1

    create :rating_rate, author: user_1, resource: article_1, scopeable: category, value: 1
    create :rating_rate, author: user_2, resource: article_1, scopeable: category, value: 2
  end

  context 'with no scopeable' do
    subject { described_class.data article_1, nil }

    it 'returns the average of value for a resource' do
      expect(subject[:average]).to eq 50.5
    end

    it 'returns the sum of values for a resource' do
      expect(subject[:sum]).to eq 101
    end

    it 'returns the count of votes for a resource' do
      expect(subject[:total]).to eq 2
    end

    it 'returns the estimate for a resource' do
      expect(subject[:estimate]).to eq 42.50000000000001
    end
  end

  context 'with scopeable' do
    subject { described_class.data article_1, category }

    it 'returns the average of value for a resource' do
      expect(subject[:average]).to eq 1.5
    end

    it 'returns the sum of values for a resource' do
      expect(subject[:sum]).to eq 3
    end

    it 'returns the count of votes for a resource' do
      expect(subject[:total]).to eq 2
    end

    it 'returns the estimate for a resource' do
      expect(subject[:estimate]).to eq 1.5
    end
  end
end
