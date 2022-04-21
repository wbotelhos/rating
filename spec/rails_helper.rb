# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'active_record/railtie'
require 'mysql2'
require 'pg'
require 'rating'

ENV['DB'] ||= 'mysql'

conn_params = {
  database: :rating_test,
  host: '127.0.0.1',
}

case ENV['DB']
when 'mysql'
  client = Mysql2::Client.new(host: '127.0.0.1', username: :root)
  conn_params[:adapter] = :mysql2
  conn_params[:username] = :root
when 'postgres'
  ENV['POSTGRES_USER'] ||= 'rating_user'
  client = PG::Connection.new(host: '127.0.0.1', user: ENV['POSTGRES_USER'], password: ENV['POSTGRES_PASSWORD'])
  conn_params.merge!(
    adapter: :postgresql,
    username: ENV['POSTGRES_USER'],
    password: ENV['POSTGRES_PASSWORD']
  )
end

client.query 'DROP DATABASE IF EXISTS rating_test;'
client.query 'CREATE DATABASE rating_test;'

ActiveRecord::Base.establish_connection(conn_params)

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |file| require file }
