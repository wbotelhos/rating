# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rates' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  before { user.rate article, 3 }

  it 'returns rates record' do
    expect(article.rates).to eq [Rating::Rate.last]
  end

  context 'when destroy author' do
    before do
      expect(Rating::Rate.where(resource: article).count).to eq 1

      user.destroy!
    end

    it 'destroys rates of that resource' do
      expect(Rating::Rate.where(resource: article).count).to eq 0
    end
  end

  context 'when destroy resource' do
    before do
      expect(Rating::Rate.where(resource: article).count).to eq 1

      article.destroy!
    end

    it 'destroys rates of that resource' do
      expect(Rating::Rate.where(resource: article).count).to eq 0
    end
  end
end
