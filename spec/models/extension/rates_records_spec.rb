# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, '.rates_records' do
  let!(:category) { create :category }

  let!(:user_1) { create :user }
  let!(:user_2) { create :user }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  let!(:rate_1) { create :rating_rate, author: user_1, resource: article_1, value: 100 }
  let!(:rate_2) { create :rating_rate, author: user_1, resource: article_2, value: 11 }
  let!(:rate_3) { create :rating_rate, author: user_1, resource: article_3, value: 10 }
  let!(:rate_4) { create :rating_rate, author: user_2, resource: article_1, value: 1 }

  let!(:rate_5) { create :rating_rate, author: user_1, resource: article_1, scopeable: category, value: 1 }
  let!(:rate_6) { create :rating_rate, author: user_2, resource: article_1, scopeable: category, value: 2 }

  it 'returns all rates that this resource received' do
    expect(article_1.rates_records).to match_array [rate_1, rate_4, rate_5, rate_6]
  end
end
