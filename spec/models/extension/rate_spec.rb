# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  it 'delegates to rate object' do
    expect(Rating::Rate).to receive(:create).with author: user, resource: article, value: 3

    user.rate article, 3
  end
end
