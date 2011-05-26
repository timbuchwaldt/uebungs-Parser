# Includes
require 'rubygems'
require 'sinatra'
require 'erb'
require 'data_mapper'
require 'models'

# Setup
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")


get '/' do
  erb :index, :locals => {:greeting => "tim"}
end