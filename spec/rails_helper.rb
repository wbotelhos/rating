# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record/railtie'
require 'mysql2'
require 'rating'

client = Mysql2::Client.new(host: '127.0.0.1', username: :root)

client.query 'DROP DATABASE IF EXISTS rating_test;'
client.query 'CREATE DATABASE IF NOT EXISTS rating_test;'

ActiveRecord::Base.establish_connection adapter: :mysql2, database: :rating_test, username: :root, host: '127.0.0.1'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
