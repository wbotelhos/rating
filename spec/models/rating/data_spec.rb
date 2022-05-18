# frozen_string_literal: true

require 'support/shared_context/with_database_records'

RSpec.describe Rating::Rating, ':data' do
  include_context 'with_database_records'

  context 'with no scopeable' do
    subject(:result) { described_class.data article_1, nil }

    it 'returns the average of value for a resource' do
      expect(result[:average]).to eq 50.5
    end

    it 'returns the sum of values for a resource' do
      expect(result[:sum]).to eq 101
    end

    it 'returns the count of votes for a resource' do
      expect(result[:total]).to eq 2
    end

    it 'returns the estimate for a resource' do
      if ENV.fetch('DB') == 'mysql'
        expect(result[:estimate]).to eq(BigDecimal('42.5000000000000000012000000505'))
      elsif ENV.fetch('DB') == 'postgres'
        expect(result[:estimate]).to eq(BigDecimal('42.5000000000000001200000000000000012505'))
      else
        raise('DB env missing!')
      end
    end
  end

  context 'with scopeable' do
    subject(:result) { described_class.data article_1, category }

    it 'returns the average of value for a resource' do
      expect(result[:average]).to eq 1.5
    end

    it 'returns the sum of values for a resource' do
      expect(result[:sum]).to eq 3
    end

    it 'returns the count of votes for a resource' do
      expect(result[:total]).to eq 2
    end

    it 'returns the estimate for a resource' do
      expect(result[:estimate]).to eq 1.5
    end
  end
end
