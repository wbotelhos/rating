# frozen_string_literal: true

require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, ':order_by_rating' do
  include_context 'with_database_records'

  context 'with default filters' do
    it 'sorts by :estimate :desc' do
      expect(Article.order_by_rating).to eq [
        article_1,
        article_2,
        article_3,
      ]
    end
  end

  context 'when filtering by :average' do
    context 'with as asc' do
      it 'orders by the given params' do
        expect(Article.order_by_rating({ column: :average, direction: :asc })).to eq [
          article_3,
          article_2,
          article_1,
        ]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :average, direction: :asc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end

    context 'with as desc' do
      it 'orders by the given params' do
        expect(Article.order_by_rating({ column: :average, direction: :desc })).to eq [
          article_1,
          article_2,
          article_3,
        ]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :average, direction: :desc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end
  end

  context 'when filtering by :estimate' do
    context 'with as asc' do
      it 'orders by the given params' do
        expect(Article.order_by_rating({ column: :estimate, direction: :asc })).to eq [
          article_3,
          article_2,
          article_1,
        ]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :estimate, direction: :asc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end

    context 'with as desc' do
      it 'orders by the given params' do
        expect(Article.order_by_rating({ column: :estimate, direction: :desc })).to eq [
          article_1,
          article_2,
          article_3,
        ]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :estimate, direction: :desc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end
  end

  context 'when filtering by :sum' do
    context 'as asc' do
      it 'orders by the given params' do
        expect(Article.order_by_rating({ column: :sum, direction: :asc })).to eq [
          article_3,
          article_2,
          article_1,
        ]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :sum, direction: :asc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end

    context 'with as desc' do
      it 'orders by the given params' do
        expect(Article.order_by_rating({ column: :sum, direction: :desc })).to eq [
          article_1,
          article_2,
          article_3,
        ]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :sum, direction: :desc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end
  end

  context 'when filtering by :total' do
    context 'with as asc' do
      it 'orders by the given params' do
        result = Article.order_by_rating({ column: :total, direction: :asc })

        expect(result[0..1]).to match_array [article_2, article_3]
        expect(result.last).to  eq article_1
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :total, direction: :asc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end

    context 'with as desc' do
      it 'orders by the given params' do
        result = Article.order_by_rating({ column: :total, direction: :desc })

        expect(result.first).to eq article_1
        expect(result[1..2]).to match_array [article_2, article_3]
      end

      context 'with scope' do
        it 'orders by the given params' do
          expect(Article.order_by_rating({ column: :total, direction: :desc, scope: category })).to eq [
            article_1,
          ]
        end
      end
    end
  end

  context 'with other resource' do
    it 'orders by the given params' do
      expect(Author.order_by_rating({ column: :total, direction: :desc })).to match_array [author_1, author_2]
    end

    context 'with scope' do
      it 'returns empty since creation has no scope' do
        expect(Author.order_by_rating({ column: :total, direction: :desc, scope: category })).to eq([])
      end
    end
  end
end
