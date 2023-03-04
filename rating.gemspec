# frozen_string_literal: true

require_relative 'lib/rating/version'

Gem::Specification.new do |spec|
  spec.author = 'Washington Botelho'
  spec.description = 'A true Bayesian rating system with scope and cache enabled.'
  spec.email = 'wbotelhos@gmail.com'
  spec.extra_rdoc_files = Dir['CHANGELOG.md', 'LICENSE', 'README.md']
  spec.files = Dir['lib/**/*']
  spec.homepage = 'https://github.com/wbotelhos/rating'
  spec.license = 'MIT'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }
  spec.name = 'rating'
  spec.summary = 'A true Bayesian rating system with scope and cache enabled.'
  spec.version = Rating::VERSION

  spec.add_dependency('activerecord')

  spec.add_development_dependency('codecov') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('database_cleaner') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('factory_bot_rails') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('mysql2') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('pg') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('pry-byebug') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('rspec-rails') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('rubocop-performance') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('rubocop-rails') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('rubocop-rspec') # rubocop:disable Gemspec/DevelopmentDependencies
  spec.add_development_dependency('shoulda-matchers') # rubocop:disable Gemspec/DevelopmentDependencies
end
