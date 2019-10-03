# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rated?' do
  let!(:author)   { create :author }
  let!(:resource) { create :article }

  context 'with no scopeable' do
    before { author.rate resource, 1 }

    context 'when has no rate for the given resource' do
      specify { expect(author.rated?(create(:article))).to eq false }
    end

    context 'when has rate for the given resource' do
      specify { expect(author.rated?(resource)).to eq true }
    end
  end

  context 'with scopeable' do
    let!(:category) { create :category }

    before { author.rate resource, 1, scope: category }

    context 'when has no rate for the given resource' do
      specify { expect(author.rated?(resource, scope: create(:category))).to eq false }
    end

    context 'when has rate for the given resource' do
      specify { expect(author.rated?(resource, scope: category)).to eq true }
    end
  end

  if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] == 'true'
    context 'with extra scopes' do
      before { author.rate resource, 1, extra_scopes: { scope_1: 'scope_1' } }

      context 'when has no rate for the given resource with given extra scopes' do
        specify { expect(author.rated?(resource, extra_scopes: { scope_1: 'missing' })).to eq false }
      end

      context 'when has rate for the given resource with given extra scopes' do
        specify { expect(author.rated?(resource, extra_scopes: { scope_1: 'scope_1' })).to eq true }
      end
    end
  end
end
