# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Rate do
  let!(:object) { build :rating_rate }

  it { expect(object).to be_valid }

  it { is_expected.to belong_to :author }
  it { is_expected.to belong_to :resource }

  it { is_expected.to validate_presence_of :author }
  it { is_expected.to validate_presence_of :resource }
  it { is_expected.to validate_presence_of :value }

  specify do
    is_expected.to validate_numericality_of(:value).is_less_than_or_equal_to(100).is_less_than_or_equal_to 100
  end

  specify do
    expect(object).to validate_uniqueness_of(:author_id)
      .scoped_to(%i[author_type resource_id resource_type])
      .case_insensitive
  end
end
