# frozen_string_literal: true

Dir[File.expand_path('db/migrate/*.rb', __dir__)].each { |file| require file }

CreateRateTable.new.change
CreateRatingTable.new.change

CreateArticlesTable.new.change
CreateAuthorsTable.new.change
CreateToysTable.new.change

CreateGlobalsTable.new.change
CreateCategoriesTable.new.change

CreateCommentsTable.new.change

CreateReviewRatingsTable.new.change
CreateReviewsTable.new.change

AddCommentOnRatingRatesTable.new.change
AddExtraScopesOnRatingRatesTable.new.change if ENV['CONFIG_ENABLED_WITH_EXTRA_SCOPES'] == 'true'
