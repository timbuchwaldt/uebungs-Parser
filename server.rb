# Includes
require 'rubygems'
require 'sinatra'
require 'erb'
require 'data_mapper'
require 'models'
require 'awesome_print'

require 'helper'
# Setup
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")


get '/' do  
  erb :index
end

get '/script.js' do
  @sum = Total.all
  ap Result.all(:fields => [:lecture])
  erb :script
end