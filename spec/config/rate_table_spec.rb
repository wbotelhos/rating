# frozen_string_literal: true

RSpec.describe Rating::Config, '.rate_table' do
  let!(:config) { described_class }

  if ENV['CONFIG_ENABLED'] != 'true'
    context 'when rating.yml does not exist' do
      it { expect(config.rate_table).to eq 'rating_rates' }
    end
  end

  if ENV['CONFIG_ENABLED'] == 'true'
    context 'when rating.yml exists' do
      it { expect(config.rate_table).to eq 'reviews' }
    end
  end
end
