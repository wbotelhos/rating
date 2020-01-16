# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, 'unscoped_rating' do
  let!(:author_1) { create :author }
  let!(:author_2) { create :author }
  let!(:author_3) { create :author }
  let!(:scope)    { create :category }

  context 'when is false' do
    let!(:resource) { create :article }

    it 'groups in different line record' do
      author_1.rate resource, 1, scope: scope
      author_2.rate resource, 2, scope: scope
      author_2.rate resource, 5

      ratings = Rating::Rating.all.order('id')

      expect(ratings.size).to eq 2

      rating = ratings[0]

      expect(rating.average.to_s).to  eq '1.5'
      expect(rating.estimate.to_s).to eq '1.5'
      expect(rating.resource).to      eq resource
      expect(rating.scopeable).to     eq scope
      expect(rating.sum).to           eq 3
      expect(rating.total).to         eq 2

      rating = ratings[1]

      expect(rating.average.to_s).to  eq '5.0'
      expect(rating.estimate.to_s).to eq '5.0'
      expect(rating.resource).to      eq resource
      expect(rating.scopeable).to     eq nil
      expect(rating.sum).to           eq 5
      expect(rating.total).to         eq 1
    end
  end

  context 'when is true' do
    let!(:resource) { create :global }

    it 'groups in the same line record' do
      author_1.rate resource, 1, scope: scope
      author_2.rate resource, 2, scope: scope
      author_2.rate resource, 5

      ratings = Rating::Rating.all.order('id')

      expect(ratings.size).to eq 1

      rating = ratings[0]

      expect(rating.average.to_s).to  eq '2.6666666666666667'
      expect(rating.estimate.to_s).to eq '2.6666666666666667'
      expect(rating.resource).to      eq resource
      expect(rating.scopeable).to     eq nil
      expect(rating.sum).to           eq 8
      expect(rating.total).to         eq 3
    end
  end

  context 'when is true and have a non scoped record first on database' do
    let!(:resource) { create :global }

    before { ::Rating::Rating.create resource: resource, scopeable: scope }

    it 'sets the result on record with no scope' do
      author_1.rate resource, 1, scope: scope
      author_2.rate resource, 2, scope: scope
      author_3.rate resource, 5

      ratings = Rating::Rating.all.order('id')

      expect(ratings.size).to eq 2

      rating = ratings[0]

      expect(rating.average.to_s).to  eq '0.0'
      expect(rating.estimate.to_s).to eq '0.0'
      expect(rating.resource).to      eq resource
      expect(rating.scopeable).to     eq scope
      expect(rating.sum).to           eq 0
      expect(rating.total).to         eq 0

      rating = ratings[1]

      expect(rating.average.to_s).to  eq '2.6666666666666667'
      expect(rating.estimate.to_s).to eq '2.6666666666666667'
      expect(rating.resource).to      eq resource
      expect(rating.scopeable).to     eq nil
      expect(rating.sum).to           eq 8
      expect(rating.total).to         eq 3
    end
  end
end
