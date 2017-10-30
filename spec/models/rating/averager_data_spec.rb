# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rating, ':averager_data' do
  subject { described_class.averager_data article_1 }

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

  it 'returns the values average of given resource type' do
    expect(subject.as_json['rating_avg']).to eq 30.5
  end

  it 'returns the average of number of records for the given resource type' do
    expect(subject.as_json['count_avg']).to eq 1.3333333333333333
  end
end
