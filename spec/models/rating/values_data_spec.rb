# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Rating, ':values_data' do
  include_context 'with_database_records'

  context 'with no scopeable' do
    subject(:result) { described_class.values_data article_1, nil }

    it 'returns the average of value for a resource' do
      expect(result.as_json['rating_avg'].to_f.to_s).to eq '50.5'
    end

    it 'returns the sum of values for a resource' do
      expect(result.as_json['rating_sum'].to_f.to_s).to eq '101.0'
    end

    it 'returns the count of votes for a resource' do
      expect(result.as_json['rating_count'].to_f.to_s).to eq '2.0'
    end
  end

  context 'with scopeable' do
    subject(:result) { described_class.values_data article_1, category }

    it 'returns the average of value for a resource' do
      expect(result.as_json['rating_avg'].to_f.to_s).to eq '1.5'
    end

    it 'returns the sum of values for a resource' do
      expect(result.as_json['rating_sum'].to_f.to_s).to eq '3.0'
    end

    it 'returns the count of votes for a resource' do
      expect(result.as_json['rating_count'].to_f.to_s).to eq '2.0'
    end
  end
end
