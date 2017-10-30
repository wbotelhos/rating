# frozen_string_literal: true

require 'database_cleaner'

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :transaction

    DatabaseCleaner.clean_with :truncation
  end

  config.before { DatabaseCleaner.start }

  config.around do |spec|
    DatabaseCleaner.cleaning do
      spec.run
    end
  end
end
