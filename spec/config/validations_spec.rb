# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Config, '.validations' do
  if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] != 'true'
    context 'when rating.yml does not exist' do
      it do
        expect(subject.validations).to eq({
          rate: {
            case_sensitive: false,
            scope:          %w[author_type resource_id resource_type scopeable_id scopeable_type],
          },
        }.deep_stringify_keys
                                         )
      end
    end
  end

  if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] == 'true'
    context 'when rating.yml exists' do
      it do
        expect(subject.validations).to eq({
          rate: {
            case_sensitive: false,
            scope:          %w[author_type resource_id resource_type scopeable_id scopeable_type scope_1 scope_2],
          },
        }.deep_stringify_keys
                                         )
      end
    end
  end
end
