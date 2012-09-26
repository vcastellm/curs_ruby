# myapp.rb
require 'sinatra'
require 'open-uri'
require "sinatra/reloader" if development?
require 'json'

#{}"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=victorcoder"

get '/' do
  uri = open("http://api.twitter.com/1/statuses/user_timeline.json?screen_name=elcibernarium")
  @statuses = uri.read
  
  @foo = JSON.parse(@statuses)

  erb :index
end