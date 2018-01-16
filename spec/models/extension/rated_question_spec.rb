# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rated?' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    context 'when has no rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: nil) { nil } }

      specify { expect(author.rated?(article)).to eq false }
    end

    context 'when has rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: nil) { double } }

      specify { expect(author.rated?(article)).to eq true }
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    context 'when has no rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: category) { nil } }

      specify { expect(author.rated?(article, scope: category)).to eq false }
    end

    context 'when has rate for the given resource' do
      before { allow(author).to receive(:rate_for).with(article, scope: category) { double } }

      specify { expect(author.rated?(article, scope: category)).to eq true }
    end
  end
end
