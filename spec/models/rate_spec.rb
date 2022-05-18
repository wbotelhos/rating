# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Rating::Rate do
  let!(:object) { build(:rating_rate) }

  it { expect(object.valid?).to be(true) }

  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:resource) }
  it { is_expected.to belong_to(:scopeable) }

  it { is_expected.to validate_presence_of(:author) }
  it { is_expected.to validate_presence_of(:resource) }
  it { is_expected.to validate_presence_of(:value) }

  it do
    expect(subject).to validate_numericality_of(:value).is_less_than_or_equal_to(100).is_less_than_or_equal_to(100)
  end

  it do
    scopes = %i[author_type resource_id resource_type scopeable_id scopeable_type]
    scopes += %i[scope_1 scope_2] if ENV.fetch('CONFIG_ENABLED_WITH_EXTRA_SCOPES', 'false') == 'true'

    expect(object).to validate_uniqueness_of(:author_id).scoped_to(scopes).case_insensitive
  end
end
