# frozen_string_literal: true

ENV['DB'] ||= 'mysql'

conn_params = { database: :rating_test, host: '127.0.0.1' }

case ENV.fetch('DB', nil)
when 'mysql'
  require 'mysql2'

  client = Mysql2::Client.new(host: conn_params[:host], username: :root)

  conn_params[:adapter] = :mysql2
  conn_params[:username] = :root
when 'postgres'
  require 'pg'

  client = PG::Connection.new(host: conn_params[:host], password: '', user: :postgres)

  conn_params[:adapter] = :postgresql
  conn_params[:username] = :postgres
end

client.query('DROP DATABASE IF EXISTS rating_test;')
client.query('CREATE DATABASE rating_test;')

ActiveRecord::Base.establish_connection(conn_params)
