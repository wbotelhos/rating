# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Extension, ':after_create' do
  context 'when creates object' do
    let!(:user) { create :user }

    it 'creates a record with zero values just to be easy to make the count' do
      rating = Rating::Rating.find_by(resource: user)

      expect(rating.average).to  eq 0
      expect(rating.estimate).to eq 0
      expect(rating.resource).to eq user
      expect(rating.sum).to      eq 0
      expect(rating.total).to    eq 0
    end
  end
end
