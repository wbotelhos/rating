# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, '.rating_warm_up' do
  context 'when scoping is nil' do
    context 'when update is made' do
      let!(:record) { create :comment }
      let!(:rating) { ::Rating::Rating.find_by resource: record }

      it 'creates the cache' do
        record.rating_warm_up scoping: nil

        expect(::Rating::Rating.all).to eq [rating]
      end

      it 'returns the cached object' do
        expect(record.rating_warm_up).to eq rating
      end
    end

    context 'when record does not exist' do
      let!(:record) { create :comment }

      before { ::Rating::Rating.destroy_all }

      it 'creates the cache' do
        record.rating_warm_up scoping: nil

        expect(::Rating::Rating.all.map(&:resource)).to eq [record]
      end

      it 'returns the cached object' do
        expect(record.rating_warm_up).to eq ::Rating::Rating.last
      end
    end
  end

  context 'when scoping is not nil' do
    context 'when update is made' do
      let!(:category_1) { create :category }
      let!(:category_2) { create :category }
      let!(:record)     { create :article, categories: [category_1, category_2] }

      it 'creates the cache' do
        record.rating_warm_up scoping: :categories

        ratings = ::Rating::Rating.all

        expect(ratings.map(&:scopeable)).to match_array [category_1, category_2]
        expect(ratings.map(&:resource)).to  match_array [record, record]
      end

      it 'returns the cached objects' do
        expect(record.rating_warm_up(scoping: :categories)).to eq ::Rating::Rating.all
      end
    end

    context 'when record does not exist' do
      let!(:category_1) { create :category }
      let!(:category_2) { create :category }
      let!(:record)     { create :article, categories: [category_1, category_2] }

      before { ::Rating::Rating.destroy_all }

      it 'creates the cache' do
        record.rating_warm_up scoping: :categories

        ratings = ::Rating::Rating.all

        expect(ratings.map(&:scopeable)).to match_array [category_1, category_2]
        expect(ratings.map(&:resource)).to  match_array [record, record]
      end

      it 'returns the cached objects' do
        expect(record.rating_warm_up(scoping: :categories)).to eq ::Rating::Rating.all
      end
    end

    context 'when a non existent scoping is given' do
      let!(:record) { create :article }

      it 'returns an empty array' do
        expect(record.rating_warm_up(scoping: :missing)).to eq []
      end
    end

    context 'when scoping is given inside array' do
      let!(:category) { create :category }
      let!(:record)   { create :article, categories: [category] }

      it 'returns the cache' do
        expect(record.rating_warm_up(scoping: [:categories])).to eq ::Rating::Rating.all
      end
    end

    context 'when scoping is given inside multiple arrays' do
      let!(:category) { create :category }
      let!(:record)   { create :article, categories: [category] }

      it 'returns the cache' do
        expect(record.rating_warm_up(scoping: [[:categories]])).to eq ::Rating::Rating.all
      end
    end

    context 'when scoping is given with nil value together' do
      let!(:category) { create :category }
      let!(:record)   { create :article, categories: [category] }

      it 'returns the cache' do
        expect(record.rating_warm_up(scoping: [[:categories, nil], nil])).to eq ::Rating::Rating.all
      end
    end
  end
end
