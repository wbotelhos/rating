# frozen_string_literal: true

require 'factory_bot'

Dir[File.expand_path('../factories/**/*.rb', __dir__)].each { |file| require file }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
