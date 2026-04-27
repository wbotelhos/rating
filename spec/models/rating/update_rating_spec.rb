# frozen_string_literal: true

require 'support/shared_context/with_database_records'

RSpec.describe Rating::Rating, '.update_rating' do
  context 'with no scopeable' do
    include_context 'with database records'

    it 'updates the rating data of the given resource' do
      record = described_class.find_by(resource: article_1)

      expect(record.average).to eq(BigDecimal('4.5'))
      expect(record.estimate).to eq(BigDecimal('2.45862298'))

      expect(record.sum).to be(9)
      expect(record.total).to be(2)
    end
  end

  context 'with scopeable' do
    include_context 'with database records'

    it 'updates the rating data of the given resource respecting the scope' do
      record = described_class.find_by(resource: article_1, scopeable: category)

      expect(record.average).to eq(BigDecimal('1.5'))
      expect(record.estimate).to eq(BigDecimal('1.60148012'))
      expect(record.sum).to be(3)
      expect(record.total).to be(2)
    end
  end

  context 'when rate table has no record' do
    let!(:resource) { create(:article) }
    let!(:scope) { nil }

    it 'calculates with counts values as zero' do
      described_class.update_rating(resource, scope)

      record = described_class.last

      expect(record.average).to eq(BigDecimal('0'))
      expect(record.estimate).to eq(BigDecimal('0'))
      expect(record.sum).to be(0)
      expect(record.total).to be(0)
    end
  end

  context 'when resource_type accumulated 1000+ rates' do
    let!(:resource) { create(:article) }

    before do
      1_000.times do
        author = create(:author)
        article = create(:article)
        create(:rating_rate, author:, resource: article, value: 5)
      end
    end

    it 'updates rating without numeric overflow on a brand new resource' do
      expect { described_class.update_rating(resource, nil) }.not_to raise_error
    end
  end

  context 'when comparing distributions with the same average' do
    let!(:author_pool) { Array.new(100) { create(:author) } }

    let!(:consistent_resource) { create(:article) }
    let!(:polarized_resource) { create(:article) }

    before do
      author_pool.each { |author| create(:rating_rate, author:, resource: consistent_resource, value: 4) }

      author_pool.each_with_index do |author, index|
        value = index < 25 ? 1 : 5
        create(:rating_rate, author:, resource: polarized_resource, value:)
      end
    end

    it 'ranks the consistent distribution above the polarized one despite same mean' do
      consistent = described_class.find_by(resource: consistent_resource)
      polarized = described_class.find_by(resource: polarized_resource)

      expect(consistent.average).to eq(polarized.average)
      expect(consistent.estimate).to be > polarized.estimate
    end
  end
end
