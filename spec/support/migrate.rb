# frozen_string_literal: true

require File.expand_path('../../lib/generators/rating/templates/db/migrate/create_rating_tables.rb', __dir__)

CreateRatingTables.new.change
CreateUsersTable.new.change
CreateArticlesTable.new.change
