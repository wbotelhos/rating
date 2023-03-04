# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Rating::Rating do
  let!(:object) { build(:rating_rating) }

  it { expect(object.valid?).to be(true) }

  it { is_expected.to belong_to(:resource) }
  it { is_expected.to belong_to(:scopeable) }

  it { is_expected.to validate_presence_of(:average) }
  it { is_expected.to validate_presence_of(:estimate) }
  it { is_expected.to validate_presence_of(:resource) }
  it { is_expected.to validate_presence_of(:sum) }
  it { is_expected.to validate_presence_of(:total) }

  it do
    expect(object).to validate_uniqueness_of(:resource_id)
      .scoped_to(%i[resource_type scopeable_id scopeable_type])
      .case_insensitive
  end
end
