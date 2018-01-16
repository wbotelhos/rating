# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, '.rating' do
  let!(:category) { create :category }

  let!(:author_1) { create :author }
  let!(:author_2) { create :author }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  before do
    create :rating_rate, author: author_1, resource: article_1, value: 100
    create :rating_rate, author: author_1, resource: article_2, value: 11
    create :rating_rate, author: author_1, resource: article_3, value: 10
    create :rating_rate, author: author_2, resource: article_1, value: 1

    create :rating_rate, author: author_1, resource: article_1, scopeable: category, value: 1
    create :rating_rate, author: author_2, resource: article_1, scopeable: category, value: 2
  end

  it 'returns all rating of this resource' do
    expect(article_1.rating_records).to match_array Rating::Rating.where(resource: article_1)
  end
end
