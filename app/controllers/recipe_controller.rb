class RecipeController < Sinatra::Base
  configure do
  	set :views, "app/views"
    set :public_dir, "public" 

    enable :sessions
    set :session_secret, "reverb_secret"
  end

  get '/new' do 
    erb :'/recipe/new'
  end

  get '/search' do 
    erb :'/recipe/search_for'
  end

  post '/search' do 
    current_user = User.find_by(user_name: session["user"])
    Scraper.new(@params["food"], user_id: current_user.id)
    @recipes = LocalRecipe.all
    erb :'/recipe/search_results'
  end
end