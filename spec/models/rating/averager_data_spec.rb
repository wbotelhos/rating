# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Rating, ':averager_data' do
  include_context 'with_database_records'

  context 'with no scopeable' do
    subject(:result) { described_class.averager_data article_1, nil }

    it 'returns the values average of given resource type' do
      expect(result.as_json['rating_avg'].to_f.to_s).to eq '30.5'
    end

    it 'returns the average of number of records for the given resource type' do
      expect(result.as_json['count_avg'].to_s).to eq '1.333333333333333333'
    end
  end

  context 'with scopeable' do
    subject(:result) { described_class.averager_data article_1, category }

    it 'returns the values average of given resource type' do
      expect(result.as_json['rating_avg'].to_f.to_s).to eq '1.5'
    end

    it 'returns the average of number of records for the given resource type' do
      expect(result.as_json['count_avg'].to_f.to_s).to eq '2.0'
    end
  end
end
