# frozen_string_literal: true

require File.expand_path('../../lib/generators/rating/templates/db/migrate/create_rating_table.rb', __dir__)
require File.expand_path('../../lib/generators/rating/templates/db/migrate/create_rate_table.rb', __dir__)

Dir[File.expand_path('db/migrate/*.rb', __dir__)].each { |file| require file }

CreateArticlesTable.new.change
CreateAuthorsTable.new.change
CreateCategoriesTable.new.change
CreateCommentsTable.new.change
CreateRateTable.new.change
CreateRatingTable.new.change
CreateReviewRatingsTable.new.change
CreateReviewsTable.new.change
AddCommentOnRatingRatesTable.new.change
AddExtraScopesOnRatingRatesTable.new.change
