# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate_for' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with author: author, extra_scopes: {}, resource: article, scopeable: nil

      author.rate_for article
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with author: author, extra_scopes: {}, resource: article, scopeable: category

      author.rate_for article, scope: category
    end
  end

  context 'with extra_scopes' do
    let!(:category) { build :category }

    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with(
        author:       author,
        extra_scopes: { scope_1: 'scope_1' },
        resource:     article,
        scopeable:    category
      )

      author.rate_for article, extra_scopes: { scope_1: 'scope_1' }, scope: category
    end
  end
end
