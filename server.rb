# Includes
require 'rubygems'
require 'sinatra'
require 'erb'
require 'data_mapper'
require 'models'

# Setup
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")


get '/' do
  @greeting = "tim"
  erb :index
end

get '/script.js' do
  erb :script
end