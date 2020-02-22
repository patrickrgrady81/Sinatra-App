class ApplicationController < Sinatra::Base
  configure do
  	set :views, "app/views"
    set :public_dir, "public" 

    enable :sessions
    set :session_secret, "reverb_secret"
  end

  get "/" do
    @session = session
  	erb :index
  end
end