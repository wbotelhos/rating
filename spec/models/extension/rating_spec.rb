# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rating' do
  let!(:user_1)  { create :user }
  let!(:article) { create :article }

  before { user_1.rate article, 1 }

  it 'returns rating record' do
    expect(article.rating).to eq Rating::Rating.last
  end

  context 'when destroy author' do
    let!(:user_2) { create :user }

    before { user_2.rate article, 2 }

    it 'does not destroy resource rating' do
      expect(Rating::Rating.where(resource: article).count).to eq 1

      user_1.destroy!

      expect(Rating::Rating.where(resource: article).count).to eq 1
    end
  end

  context 'when destroy resource' do
    it 'destroys resource rating too' do
      expect(Rating::Rating.where(resource: article).count).to eq 1

      article.destroy!

      expect(Rating::Rating.where(resource: article).count).to eq 0
    end
  end
end
