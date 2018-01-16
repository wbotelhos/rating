# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate_for' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with author: author, resource: article, scopeable: nil

      author.rate_for article
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with author: author, resource: article, scopeable: category

      author.rate_for article, scope: category
    end
  end
end
