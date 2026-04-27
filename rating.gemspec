# frozen_string_literal: true

require_relative 'lib/rating/version'

Gem::Specification.new do |spec|
  spec.author = 'Washington Botelho'
  spec.description = 'A confidence-based rating system with scope and cache enabled.'
  spec.email = 'wbotelhos@gmail.com'
  spec.extra_rdoc_files = Dir['CHANGELOG.md', 'LICENSE', 'README.md']
  spec.files = Dir['lib/**/*']
  spec.homepage = 'https://github.com/wbotelhos/rating'
  spec.license = 'MIT'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }
  spec.name = 'rating'
  spec.required_ruby_version = '>= 3.3'
  spec.summary = 'A confidence-based rating system with scope and cache enabled.'
  spec.version = Rating::VERSION

  spec.add_dependency('activerecord')
end
