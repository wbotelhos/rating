# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, '.rating' do
  include_context 'with_database_records'

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

      author_1.destroy!

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
