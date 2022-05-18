# frozen_string_literal: true

require 'support/shared_context/with_database_records'

RSpec.describe Rating::Rating, ':update_rating' do
  context 'with no scopeable' do
    include_context 'with_database_records'

    it 'updates the rating data of the given resource' do
      record = described_class.find_by(resource: article_1)

      expect(record.average).to  eq(BigDecimal('50.5'))
      expect(record.estimate).to eq(BigDecimal('42.5'))
      expect(record.sum).to      be(101)
      expect(record.total).to    be(2)
    end
  end

  context 'with scopeable' do
    include_context 'with_database_records'

    it 'updates the rating data of the given resource respecting the scope' do
      record = described_class.find_by(resource: article_1, scopeable: category)

      expect(record.average).to  eq(BigDecimal('1.5'))
      expect(record.estimate).to eq(BigDecimal('1.5'))
      expect(record.sum).to      be(3)
      expect(record.total).to    be(2)
    end
  end

  context 'when rate table has no record' do
    let!(:resource) { create(:article) }
    let!(:scope) { nil }

    it 'calculates with counts values as zero' do
      described_class.update_rating(resource, scope)

      record = described_class.last

      expect(record.average).to  eq(BigDecimal('0.0'))
      expect(record.estimate).to eq(BigDecimal('0.0'))
      expect(record.sum).to      be(0)
      expect(record.total).to    be(0)
    end
  end
end
