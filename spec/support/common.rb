# frozen_string_literal: true

require 'rspec/rails'

RSpec.configure do |config|
  config.filter_run_when_matching :focus

  config.disable_monkey_patching!
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.infer_base_class_for_anonymous_controllers = false
  config.order                                      = :random
  config.profile_examples                           = true
end
