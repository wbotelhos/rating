# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rate, ':rate_for' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    context 'when rate does not exist' do
      it { expect(described_class.rate_for(author: author, resource: article)).to eq nil }
    end

    context 'when rate exists' do
      let!(:record) do
        described_class.create author: author, extra_scopes: {}, metadata: {}, resource: article, value: 3
      end

      it 'returns the record' do
        expect(described_class.rate_for(author: author, resource: article)).to eq record
      end
    end
  end

  context 'with scopeable' do
    let!(:category) { create :category }

    context 'when rate does not exist' do
      it do
        expect(described_class.rate_for(author: author, resource: article, scopeable: category)).to eq nil
      end
    end

    context 'when rate exists' do
      let!(:record) do
        described_class.create(
          author:       author,
          extra_scopes: {},
          metadata:     {},
          resource:     article,
          scopeable:    category,
          value:        3
        )
      end

      it 'returns the record' do
        query = described_class.rate_for(author: author, resource: article, scopeable: category)

        expect(query).to eq record
      end
    end
  end

  if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] == 'true'
    context 'with extra scopes' do
      let!(:category) { create :category }

      context 'when matches all attributes including the extra scopes' do
        let!(:record) do
          described_class.create(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
            metadata:     {},
            resource:     article,
            scopeable:    category,
            value:        1
          )
        end

        it 'returns the record' do
          result = described_class.rate_for(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
            resource:     article,
            scopeable:    category
          )

          expect(result).to eq record
        end
      end

      context 'when matches all attributes but at least one extra scopes' do
        before do
          described_class.create(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
            metadata:     {},
            resource:     article,
            scopeable:    category,
            value:        1
          )
        end

        it 'does not return the record' do
          result = described_class.rate_for(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_missing' },
            resource:     article,
            scopeable:    category
          )

          expect(result).to eq nil
        end
      end
    end
  end
end
