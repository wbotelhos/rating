# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rating, ':values_data' do
  let!(:category) { create :category }

  let!(:author_1) { create :author }
  let!(:author_2) { create :author }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  before do
    create :rating_rate, author: author_1, resource: article_1, value: 100
    create :rating_rate, author: author_1, resource: article_2, value: 11
    create :rating_rate, author: author_1, resource: article_3, value: 10
    create :rating_rate, author: author_2, resource: article_1, value: 4

    create :rating_rate, author: author_1, resource: article_1, scopeable: category, value: 1
    create :rating_rate, author: author_2, resource: article_1, scopeable: category, value: 2
  end

  context 'with no scopeable' do
    subject { described_class.values_data article_1, nil }

    it 'returns the average of value for a resource' do
      expect(subject.as_json['rating_avg']).to eq 52.0
    end

    it 'returns the sum of values for a resource' do
      expect(subject.as_json['rating_sum']).to eq 104
    end

    it 'returns the count of votes for a resource' do
      expect(subject.as_json['rating_count']).to eq 2
    end
  end

  context 'with scopeable' do
    subject { described_class.values_data article_1, category }

    it 'returns the average of value for a resource' do
      expect(subject.as_json['rating_avg']).to eq 1.5
    end

    it 'returns the sum of values for a resource' do
      expect(subject.as_json['rating_sum']).to eq 3
    end

    it 'returns the count of votes for a resource' do
      expect(subject.as_json['rating_count']).to eq 2
    end
  end
end
