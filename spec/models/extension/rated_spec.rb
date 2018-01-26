# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, ':rated' do
  include_context 'with_database_records'

  context 'with no scope' do
    it 'returns rates made by this author' do
      expect(author_1.rated).to match_array [rate_1, rate_2, rate_3]
    end
  end

  context 'with no scope' do
    it 'returns scoped rates made by this author' do
      expect(author_1.rated(scope: category)).to eq [rate_5]
    end
  end

  context 'when destroy author' do
    it 'destroys rates of that author' do
      expect(Rating::Rate.where(author: author_1).count).to eq 4

      author_1.destroy!

      expect(Rating::Rate.where(author: author_1).count).to eq 0
    end
  end

  context 'when destroy resource rated by author' do
    it 'destroys rates of that resource' do
      expect(Rating::Rate.where(resource: article_1).count).to eq 4

      article_1.destroy!

      expect(Rating::Rate.where(resource: article_1).count).to eq 0
    end
  end
end
