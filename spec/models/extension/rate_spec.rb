# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:create).with author: user, resource: article, scopeable: nil, value: 3

      user.rate article, 3
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:create).with author: user, resource: article, scopeable: category, value: 3

      user.rate article, 3, scope: category
    end
  end
end
