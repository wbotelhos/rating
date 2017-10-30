# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':rate_for' do
  let!(:user)    { create :user }
  let!(:article) { create :article }

  it 'delegates to rate object' do
    expect(Rating::Rate).to receive(:rate_for).with author: user, resource: article

    user.rate_for article
  end
end
