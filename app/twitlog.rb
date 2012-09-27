# myapp.rb
require 'sinatra'
require 'open-uri'
require 'sinatra/reloader' if development?
require 'json'
require 'sqlite3'

#{}"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=victorcoder"
set :db, Proc.new { create_db }

get '/' do
  uri = open("http://api.twitter.com/1/statuses/user_timeline.json?screen_name=elcibernarium")
  result = uri.read

  @statuses = JSON.parse(result)

  insert_twitts(@statuses)

  erb :index
end

get '/search/:query' do
  @twits = []

  begin
    @twits = settings.db.execute("SELECT * FROM twits WHERE text LIKE ?", "%#{params[:query]}%")  
  rescue Exception => e
    p "============"
    p e.message
  end

  erb :search
end

def create_db
  # Open a database
  db = SQLite3::Database.new "twitlog.db"

  # Create a database
  rows = db.execute 'CREATE TABLE IF NOT EXISTS twits (id int, text varchar(140));'
  db
end

def insert_twitts(statuses)
  statuses.each do |stat|
    settings.db.execute "insert into twits values ( ?, ? )", stat["id"], stat["text"]
  end
end