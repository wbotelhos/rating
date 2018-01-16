# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/with_database_records'

RSpec.describe Rating::Extension, '.rating' do
  include_context 'with_database_records'

  it 'returns all rating of this resource' do
    expect(article_1.rating_records).to match_array Rating::Rating.where(resource: article_1)
  end
end
