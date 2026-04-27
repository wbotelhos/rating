# frozen_string_literal: true

RSpec.describe Rating::Extension, '#rate_for' do
  let!(:author)  { create(:author) }
  let!(:article) { create(:article) }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:rate_for)

      author.rate_for article

      expect(Rating::Rate).to have_received(:rate_for).with author:, extra_scopes: {}, resource: article,
        scopeable: nil
    end
  end

  context 'with scopeable' do
    let!(:category) { build(:category) }

    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:rate_for)

      author.rate_for article, scope: category

      expect(Rating::Rate).to have_received(:rate_for).with author:, extra_scopes: {}, resource: article,
        scopeable: category
    end
  end

  context 'with extra_scopes' do
    let!(:category) { build(:category) }

    it 'delegates to rate object' do
      allow(Rating::Rate).to receive(:rate_for)

      author.rate_for article, extra_scopes: { scope_1: 'scope_1' }, scope: category

      expect(Rating::Rate).to have_received(:rate_for).with(
        author:,
        extra_scopes: { scope_1: 'scope_1' },
        resource:     article,
        scopeable:    category
      )
    end
  end
end
