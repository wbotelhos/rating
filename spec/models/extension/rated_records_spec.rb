# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, '.rated_records' do
  include_context 'with_database_records'

  it 'returns all rates that this author gave' do
    expect(author_1.rated_records).to match_array [rate_1, rate_2, rate_3, rate_5]
  end
end
