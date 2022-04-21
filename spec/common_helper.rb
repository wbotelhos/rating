# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'support/coverage'

require 'active_record/railtie'
require 'debug'
require 'rating'

require 'support/common'
require 'support/database'
require 'support/database_cleaner'
require 'support/factory_bot'
require 'support/migrate'
require 'support/models'
