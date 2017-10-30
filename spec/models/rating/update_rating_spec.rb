# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rating, ':update_rating' do
  let!(:user_1) { create :user }
  let!(:user_2) { create :user }

  let!(:article_1) { create :article }
  let!(:article_2) { create :article }
  let!(:article_3) { create :article }

  before do
    create :rating_rate, author: user_1, resource: article_1, value: 100
    create :rating_rate, author: user_1, resource: article_2, value: 11
    create :rating_rate, author: user_1, resource: article_3, value: 10
    create :rating_rate, author: user_2, resource: article_1, value: 1
  end

  it 'updates the rating data of the given resource' do
    record = described_class.find_by(resource: article_1)

    expect(record.average).to  eq 50.50000000000001
    expect(record.estimate).to eq 42.50000000000001
    expect(record.sum).to      eq 101
    expect(record.total).to    eq 2
  end
end
