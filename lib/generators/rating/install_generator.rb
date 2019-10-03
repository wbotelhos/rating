# frozen_string_literal: true

module Rating
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    desc 'Creates Rating migration'

    def create_migration
      template 'db/migrate/create_rating_table.rb', "db/migrate/#{timestamp(0)}_create_rating_table.rb"
      template 'db/migrate/create_rate_table.rb', "db/migrate/#{timestamp(1)}_create_rate_table.rb"
    end

    private

    def time
      @time ||= Time.current
    end

    def timestamp(seconds)
      (time + seconds.seconds).strftime '%Y%m%d%H%M%S'
    end
  end
end
