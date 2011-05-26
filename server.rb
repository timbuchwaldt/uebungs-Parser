# Includes
require 'rubygems'
require 'sinatra'
require 'erb'
require 'data_mapper'
require 'models'
require 'awesome_print'
# Setup
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")


get '/' do
 @sum=Total.all
  
  erb :index
end

get '/script.js' do
  erb :script
end