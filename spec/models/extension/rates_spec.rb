# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, ':rates' do
  include_context 'with_database_records'

  context 'with no scope' do
    it 'returns rates that this resource received' do
      expect(article_1.rates).to match_array [rate_1, rate_4]
    end
  end

  context 'with scope' do
    it 'returns scoped rates that this resource received' do
      expect(article_1.rates(scope: category)).to match_array [rate_5, rate_6]
    end
  end

  context 'when destroy author' do
    it 'destroys rates of that author' do
      expect(Rating::Rate.where(author: author_1).count).to eq 4

      author_1.destroy!

      expect(Rating::Rate.where(author: author_1).count).to eq 0
    end
  end

  context 'when destroy resource' do
    it 'destroys rates of that resource' do
      expect(Rating::Rate.where(resource: article_1).count).to eq 4

      article_1.destroy!

      expect(Rating::Rate.where(resource: article_1).count).to eq 0
    end
  end
end
