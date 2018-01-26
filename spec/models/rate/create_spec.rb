# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rate, ':create' do
  let!(:author)  { create :author }
  let!(:article) { create :article }

  context 'with no scopeable' do
    before { described_class.create author: author, resource: article, value: 3 }

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

      before { described_class.create author: author_2, resource: article, value: 4 }

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

    before { described_class.create author: author, resource: article, scopeable: category, value: 3 }

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

      before { described_class.create author: author_2, resource: article, scopeable: category, value: 4 }

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
    before { AddCommentOnRatingRatesTable.new.change }

    context 'with nil value' do
      it 'creates a rate entry ignoring metadata' do
        described_class.create author: author, metadata: nil, resource: article, value: 3

        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.comment).to  eq nil
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end
    end

    context 'with empty value' do
      it 'creates a rate entry ignoring metadata' do
        described_class.create author: author, metadata: '', resource: article, value: 3

        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.comment).to  eq nil
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end
    end

    context 'with hash value' do
      it 'creates a rate entry with metadata included' do
        described_class.create author: author, metadata: { comment: 'comment' }, resource: article, value: 3

        rate = described_class.last

        expect(rate.author).to   eq author
        expect(rate.comment).to  eq 'comment'
        expect(rate.resource).to eq article
        expect(rate.value).to    eq 3
      end
    end
  end
end
