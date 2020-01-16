# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rate, ':create' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    before { described_class.create author: author, extra_scopes: {}, metadata: {}, resource: article, value: 3 }

    context 'when rate does not exist yet' do
      it 'creates a rate entry' do
        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end

      it 'creates a rating entry' do
        rating = Rating::Rating.last

        expect(rating.average).to  eq 3
        expect(rating.estimate).to eq 3
        expect(rating.resource).to eq article
        expect(rating.sum).to      eq 3
        expect(rating.total).to    eq 1
      end
    end

    context 'when rate already exists' do
      let!(:author_2) { create :author }

      before { described_class.create author: author_2, extra_scopes: {}, metadata: {}, resource: article, value: 4 }

      it 'creates one more rate entry' do
        rates = described_class.where(author: [author, author_2]).order('created_at asc')

        expect(rates.size).to eq 2

        rate = rates[0]

        expect(rate.author).to   eq author
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3

        rate = rates[1]

        expect(rate.author).to   eq author_2
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 4
      end

      it 'updates the unique rating entry' do
        rating = Rating::Rating.find_by(resource: article)

        expect(rating.average).to  eq 3.5
        expect(rating.estimate).to eq 3.5
        expect(rating.resource).to eq article
        expect(rating.sum).to      eq 7
        expect(rating.total).to    eq 2
      end
    end
  end

  context 'with scopeable' do
    let!(:category) { create :category }

    before do
      described_class.create(
        author:       author,
        extra_scopes: {},
        metadata:     {},
        resource:     article,
        scopeable:    category,
        value:        3
      )
    end

    context 'when rate does not exist yet' do
      it 'creates a rate entry' do
        rate = described_class.last

        expect(rate.author).to    eq author
        expect(rate.resource).to  eq article
        expect(rate.scopeable).to eq category
        expect(rate.value).to     eq 3
      end

      it 'creates a rating entry' do
        rating = Rating::Rating.last

        expect(rating.average).to   eq 3
        expect(rating.estimate).to  eq 3
        expect(rating.resource).to  eq article
        expect(rating.scopeable).to eq category
        expect(rating.sum).to       eq 3
        expect(rating.total).to     eq 1
      end
    end

    context 'when rate already exists' do
      let!(:author_2) { create :author }

      before do
        described_class.create(
          author:       author_2,
          extra_scopes: {},
          metadata:     {},
          resource:     article,
          scopeable:    category,
          value:        4
        )
      end

      it 'creates one more rate entry' do
        rates = described_class.where(author: [author, author_2]).order('created_at asc')

        expect(rates.size).to eq 2

        rate = rates[0]

        expect(rate.author).to    eq author
        expect(rate.resource).to  eq article
        expect(rate.scopeable).to eq category
        expect(rate.value).to     eq 3

        rate = rates[1]

        expect(rate.author).to    eq author_2
        expect(rate.resource).to  eq article
        expect(rate.scopeable).to eq category
        expect(rate.value).to     eq 4
      end

      it 'updates the unique rating entry' do
        rating = Rating::Rating.find_by(resource: article, scopeable: category)

        expect(rating.average).to   eq 3.5
        expect(rating.estimate).to  eq 3.5
        expect(rating.resource).to  eq article
        expect(rating.scopeable).to eq category
        expect(rating.sum).to       eq 7
        expect(rating.total).to     eq 2
      end
    end
  end

  context 'with metadata' do
    context 'with nil value' do
      it 'creates a rate entry ignoring metadata' do
        described_class.create author: author, extra_scopes: {}, metadata: nil, resource: article, value: 3

        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.comment).to  eq nil
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end
    end

    context 'with empty value' do
      it 'creates a rate entry ignoring metadata' do
        described_class.create author: author, extra_scopes: {}, metadata: '', resource: article, value: 3

        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.comment).to  eq nil
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end
    end

    context 'with hash value' do
      it 'creates a rate entry with metadata included' do
        described_class.create(
          author:       author,
          extra_scopes: {},
          metadata:     { comment: 'comment' },
          resource:     article,
          value:        3
        )

        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.comment).to  eq 'comment'
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end
    end

    context 'when already has an entry' do
      before do
        described_class.create(
          author:       author,
          extra_scopes: {},
          metadata:     { comment: 'comment' },
          resource:     article,
          value:        1
        )
      end

      context 'when value is the same' do
        it 'still updates metadata' do
          described_class.create(
            author:       author,
            extra_scopes: {},
            metadata:     { comment: 'comment.updated' },
            resource:     article,
            value:        1
          )

          rates = described_class.all

          expect(rates.size).to eq 1

          rate = rates[0]

          expect(rate.author).to   eq author
          expect(rate.comment).to  eq 'comment.updated'
          expect(rate.resource).to eq article
          expect(rate.value).to    eq 1
        end
      end

      context 'when value is different same' do
        it 'still updates metadata' do
          described_class.create(
            author:       author,
            extra_scopes: {},
            metadata:     { comment: 'comment.updated' },
            resource:     article,
            value:        2
          )

          rates = described_class.all

          expect(rates.size).to eq 1

          rate = rates[0]

          expect(rate.author).to   eq author
          expect(rate.comment).to  eq 'comment.updated'
          expect(rate.resource).to eq article
          expect(rate.value).to    eq 2
        end
      end
    end
  end

  if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] == 'true'
    context 'with extra scopes' do
      let!(:category) { create :category }

      it 'creates a rate entry' do
        described_class.create(
          author:       author,
          extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
          metadata:     {},
          resource:     article,
          scopeable:    category,
          value:        1
        )

        rate = described_class.last

        expect(rate.author).to    eq author
        expect(rate.resource).to  eq article
        expect(rate.scope_1).to   eq 'scope_1'
        expect(rate.scope_2).to   eq 'scope_2'
        expect(rate.scopeable).to eq category
        expect(rate.value).to     eq 1
      end

      it 'creates a rating entry' do
        described_class.create(
          author:       author,
          extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
          metadata:     {},
          resource:     article,
          scopeable:    category,
          value:        1
        )

        rating = Rating::Rating.last

        expect(rating.average).to   eq 1
        expect(rating.estimate).to  eq 1
        expect(rating.resource).to  eq article
        expect(rating.scopeable).to eq category
        expect(rating.sum).to       eq 1
        expect(rating.total).to     eq 1
      end

      context 'when rate already exists' do
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

        it 'updates the rate entry' do
          described_class.create(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
            metadata:     {},
            resource:     article,
            scopeable:    category,
            value:        2
          )

          rates = described_class.all

          expect(rates.size).to eq 1

          rate = rates[0]

          expect(rate.author).to    eq author
          expect(rate.resource).to  eq article
          expect(rate.scope_1).to   eq 'scope_1'
          expect(rate.scope_2).to   eq 'scope_2'
          expect(rate.scopeable).to eq category
          expect(rate.value).to     eq 2
        end

        it 'updates the unique rating entry' do
          described_class.create(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
            metadata:     {},
            resource:     article,
            scopeable:    category,
            value:        2
          )

          ratings = Rating::Rating.all

          expect(ratings.size).to eq 1

          rating = ratings[0]

          expect(rating.average).to   eq 2
          expect(rating.estimate).to  eq 2
          expect(rating.resource).to  eq article
          expect(rating.scopeable).to eq category
          expect(rating.sum).to       eq 2
          expect(rating.total).to     eq 1
        end
      end

      context 'when rate already exists but with at least one extra scope different' do
        before do
          described_class.create(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_2' },
            metadata:     {},
            resource:     article,
            scopeable:    category,
            value:        1
          )

          described_class.create(
            author:       author,
            extra_scopes: { scope_1: 'scope_1', scope_2: 'scope_missing' },
            metadata:     {},
            resource:     article,
            scopeable:    category,
            value:        2
          )
        end

        it 'creates a new rate entry' do
          rates = described_class.all

          expect(rates.size).to eq 2

          rate = rates[0]

          expect(rate.author).to    eq author
          expect(rate.resource).to  eq article
          expect(rate.scope_1).to   eq 'scope_1'
          expect(rate.scope_2).to   eq 'scope_2'
          expect(rate.scopeable).to eq category
          expect(rate.value).to     eq 1

          rate = rates[1]

          expect(rate.author).to    eq author
          expect(rate.resource).to  eq article
          expect(rate.scope_1).to   eq 'scope_1'
          expect(rate.scope_2).to   eq 'scope_missing'
          expect(rate.scopeable).to eq category
          expect(rate.value).to     eq 2
        end

        it 'updates the unique rating entry' do
          ratings = Rating::Rating.all

          expect(ratings.size).to eq 1

          rating = ratings[0]

          expect(rating.average).to   eq 1.5
          expect(rating.estimate).to  eq 1.5
          expect(rating.resource).to  eq article
          expect(rating.scopeable).to eq category
          expect(rating.sum).to       eq 3
          expect(rating.total).to     eq 2
        end
      end
    end
  end
end
