# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record/railtie'
require 'mysql2'
require 'pry-byebug'
require 'rating'

client = Mysql2::Client.new(host: :localhost, username: :root)

client.query 'DROP DATABASE IF EXISTS rating_test;'
client.query 'CREATE DATABASE IF NOT EXISTS rating_test;'

ActiveRecord::Base.establish_connection adapter: :mysql2, database: :rating_test, username: :root

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
