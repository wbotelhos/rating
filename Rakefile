# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task default: :spec

desc 'Runs tests with config enabled'
task :spec_config do
  directory_config = File.expand_path('config')
  unsafe_path      = ['', '/', '.', './'].include?(directory_config)

  `mkdir -p #{directory_config}`

  File.open(File.expand_path('config/rating.yml'), 'w+') do |file|
    file.write "rating:\n  rate_table: 'reviews'\n  rating_table: 'review_ratings'"
  end

  ENV['CONFIG_ENABLED'] = 'true'

  Rake::Task['spec'].invoke

  FileUtils.rm_rf(directory_config) unless unsafe_path
end
