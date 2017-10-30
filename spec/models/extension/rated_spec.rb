# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rated' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  before { user.rate article, 3 }

  it 'returns rates made by the caller' do
    expect(user.rated).to eq [Rating::Rate.find_by(resource: article)]
  end

  context 'when destroy author' do
    before do
      expect(Rating::Rate.where(author: user).count).to eq 1

      user.destroy!
    end

    it 'destroys rates of this author' do
      expect(Rating::Rate.where(author: user).count).to eq 0
    end
  end

  context 'when destroy resource rated by author' do
    before do
      expect(Rating::Rate.where(resource: article).count).to eq 1

      article.destroy!
    end

    it 'destroys rates for that resource' do
      expect(Rating::Rate.where(resource: article).count).to eq 0
    end
  end
end
