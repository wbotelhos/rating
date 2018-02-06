# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Rating, ':update_rating' do
  include_context 'with_database_records'

  context 'with no scopeable' do
    it 'updates the rating data of the given resource' do
      record = described_class.find_by(resource: article_1)

      expect(record.average).to  eq 50.5
      expect(record.estimate).to eq 42.5
      expect(record.sum).to      eq 101
      expect(record.total).to    eq 2
    end
  end

  context 'with scopeable' do
    it 'updates the rating data of the given resource respecting the scope' do
      record = described_class.find_by(resource: article_1, scopeable: category)

      expect(record.average).to  eq 1.5
      expect(record.estimate).to eq 1.5
      expect(record.sum).to      eq 3
      expect(record.total).to    eq 2
    end
  end
end
