# frozen_string_literal: true

require 'mysql2'
require 'pg'

ENV['DB'] ||= 'mysql'

conn_params = {
  database: :rating_test,
  host: '127.0.0.1',
}

case ENV.fetch('DB', nil)
when 'mysql'
  client = Mysql2::Client.new(host: '127.0.0.1', username: :root)
  conn_params[:adapter] = :mysql2
  conn_params[:username] = :root
when 'postgres'
  ENV['POSTGRES_USER'] ||= 'rating_user'
  client = PG::Connection.new(host: '127.0.0.1', user: ENV.fetch('POSTGRES_USER', nil),
    password: ENV.fetch('POSTGRES_PASSWORD', nil)
  )
  conn_params.merge!(
    adapter: :postgresql,
    username: ENV.fetch('POSTGRES_USER', nil),
    password: ENV.fetch('POSTGRES_PASSWORD', nil)
  )
end

client.query('DROP DATABASE IF EXISTS rating_test;')
client.query('CREATE DATABASE rating_test;')

ActiveRecord::Base.establish_connection(conn_params)
