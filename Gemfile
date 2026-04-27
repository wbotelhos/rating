# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  gem 'rubocop-factory_bot'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
end

group :test do
  gem 'codecov'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :mysql, optional: true do
  gem 'mysql2'
end

group :postgres, optional: true do
  gem 'pg'
end
