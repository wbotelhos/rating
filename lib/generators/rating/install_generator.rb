# frozen_string_literal: true

module Rating
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    desc 'configure Rating'

    def create_migration
      version = Time.current.strftime('%Y%m%d%H%M%S')

      template 'db/migrate/create_rating_tables.rb', "db/migrate/#{version}_create_rating_tables.rb"
    end
  end
end
