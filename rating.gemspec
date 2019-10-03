# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rating/version'

Gem::Specification.new do |spec|
  spec.author      = 'Washington Botelho'
  spec.description = 'A true Bayesian rating system with scope and cache enabled.'
  spec.email       = 'wbotelhos@gmail.com'
  spec.files       = Dir['lib/**/*'] + %w[CHANGELOG.md LICENSE README.md]
  spec.homepage    = 'https://github.com/wbotelhos/rating'
  spec.license     = 'MIT'
  spec.name        = 'rating'
  spec.platform    = Gem::Platform::RUBY
  spec.summary     = 'A true Bayesian rating system with scope and cache enabled.'
  spec.test_files  = Dir['spec/**/*']
  spec.version     = Rating::VERSION

  spec.add_dependency 'activerecord', '>= 4.2', '< 6'

  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'shoulda-matchers'
end
