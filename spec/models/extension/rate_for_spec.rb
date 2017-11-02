# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate_for' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  context 'with no scopeable' do
    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with author: user, resource: article, scopeable: nil

      user.rate_for article
    end
  end

  context 'with scopeable' do
    let!(:category) { build :category }

    it 'delegates to rate object' do
      expect(Rating::Rate).to receive(:rate_for).with author: user, resource: article, scopeable: category

      user.rate_for article, scope: category
    end
  end
end
