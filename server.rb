require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'erb'
require 'models'
require 'helper'
# Setup
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/test.db")


get '/' do  
  @sum = Total.all
  @results = Result
  erb :index
end

get '/script.js' do
  erb :script
end