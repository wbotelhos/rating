# frozen_string_literal: true

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task default: :spec

desc 'Runs tests with config enabled for extra scopes'
task :spec_config_with_extra_scopes do
  directory_config = File.expand_path('config')

  `mkdir -p #{directory_config}`

  File.open(File.expand_path('config/rating.yml'), 'w+') do |file|
    file.write %(
rating:
  validations:
    rate:
      scope:
        - author_type
        - resource_id
        - resource_type
        - scopeable_id
        - scopeable_type
        - scope_1
        - scope_2
    )
  end

  ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] = 'true'

  Rake::Task['spec'].invoke

  FileUtils.rm_rf(directory_config)
end

desc 'Runs tests with config enabled'
task :spec_config do
  directory_config = File.expand_path('config')

  `mkdir -p #{directory_config}`

  File.open(File.expand_path('config/rating.yml'), 'w+') do |file|
    file.write "rating:\n  rate_table: 'reviews'\n  rating_table: 'review_ratings'"
  end

  ENV['CONFIG_ENABLED'] = 'true'

  Rake::Task['spec'].invoke

  FileUtils.rm_rf(directory_config)
end
