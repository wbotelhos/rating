# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rate, ':rate_for' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  context 'when rate does not exist' do
    specify { expect(described_class.rate_for(author: user, resource: article)).to eq nil }
  end

  context 'when rate does not exist' do
    before { described_class.create author: user, resource: article, value: 3 }

    it 'returns the record' do
      expect(described_class.rate_for(author: user, resource: article)).to eq described_class.last
    end
  end
end
