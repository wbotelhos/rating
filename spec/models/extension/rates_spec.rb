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

  if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] == 'true'
    context 'with extra scopes' do
      let!(:extra_scopes_rate) { author_1.rate article_1, 1, extra_scopes: { scope_1: 'scope_1' } }

      it 'returns records considering the extra scopes' do
        expect(article_1.rates(extra_scopes: { scope_1: 'scope_1' })).to eq [extra_scopes_rate]
      end
    end
  end
end
