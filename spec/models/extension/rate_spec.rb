# frozen_string_literal: true

RSpec.describe Rating::Extension, '#rate' do
  let!(:author)  { create(:author) }
  let!(:article) { create(:article) }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:create)

      author.rate article, 3

      expect(Rating::Rate).to have_received(:create).with(
        author:, extra_scopes: {}, metadata: {}, resource: article, scopeable: nil, value: 3
      )
    end
  end

  context 'with scopeable' do
    let!(:category) { build(:category) }

    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:create)

      author.rate article, 3, scope: category

      expect(Rating::Rate).to have_received(:create).with(
        author:, extra_scopes: {}, metadata: {}, resource: article, scopeable: category, value: 3
      )
    end
  end

  context 'with no metadata' do
    it 'delegates an empty hash to rate object' do
      allow(Rating::Rate).to receive(:create)

      author.rate article, 3

      expect(Rating::Rate).to have_received(:create).with(
        author:, extra_scopes: {}, resource: article, metadata: {}, scopeable: nil, value: 3
      )
    end
  end

  context 'with metadata' do
    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:create)

      author.rate article, 3, metadata: { comment: 'comment' }

      expect(Rating::Rate).to have_received(:create).with(
        author:, extra_scopes: {}, metadata: { comment: 'comment' }, resource: article, scopeable: nil, value: 3
      )
    end
  end

  context 'with extra_scopes' do
    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:create)

      author.rate article, 3, extra_scopes: { scope_1: 'scope_1' }, metadata: { comment: 'comment' }

      expect(Rating::Rate).to have_received(:create).with(
        author:,
        extra_scopes: { scope_1: 'scope_1' },
        metadata: { comment: 'comment' },
        resource: article,
        scopeable: nil,
        value: 3
      )
    end
  end
end
