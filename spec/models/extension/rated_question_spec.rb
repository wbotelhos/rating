# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rated?' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    context 'when has no rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: nil).and_return nil }

      specify { expect(author.rated?(article)).to eq false }
    end

    context 'when has rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: nil).and_return double }

      specify { expect(author.rated?(article)).to eq true }
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    context 'when has no rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: category).and_return nil }

      specify { expect(author.rated?(article, scope: category)).to eq false }
    end

    context 'when has rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: category).and_return double }

      specify { expect(author.rated?(article, scope: category)).to eq true }
    end
  end
end
