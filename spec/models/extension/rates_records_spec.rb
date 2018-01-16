# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, '.rates_records' do
  include_context 'with_database_records'

  it 'returns all rates that this resource received' do
    expect(article_1.rates_records).to match_array [rate_1, rate_4, rate_5, rate_6]
  end
end
