# frozen_string_literal: true

RSpec.describe Rating::Config, '.rating_table' do
  let!(:config) { described_class }

  if ENV['CONFIG_ENABLED'] != 'true'
    context 'when rating.yml does not exist' do
      it { expect(config.rating_table).to eq 'rating_ratings' }
    end
  end

  if ENV['CONFIG_ENABLED'] == 'true'
    context 'when rating.yml exists' do
      it { expect(config.rating_table).to eq 'review_ratings' }
    end
  end
end
