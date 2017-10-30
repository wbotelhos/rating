# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rated?' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  context 'when has no rate for the given resource' do
    before { allow(user).to receive(:rate_for).with(article) { nil } }

    specify { expect(user.rated?(article)).to eq false }
  end

  context 'when has rate for the given resource' do
    before { allow(user).to receive(:rate_for).with(article) { double } }

    specify { expect(user.rated?(article)).to eq true }
  end
end
