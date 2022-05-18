# frozen_string_literal: true

require 'rspec/rails'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.infer_spec_type_from_file_location!

  config.order = :random
end
