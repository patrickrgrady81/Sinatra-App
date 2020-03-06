class RecipeController < ApplicationController

  get '/users/:user_name/recipes/new' do 
    erb :'/recipe/new'
  end

  post '/users/:user_name/recipes/new' do
    raise params.inspect
  end

  get '/users/:user_name/recipes/search' do 
    @current_user = User.find_by(user_name: session["user"])
    erb :'/recipe/search_for'
  end

  post "/users/recipes/search" do 

    current_user = User.find_by(user_name: session["user"])

    # get all the temp recipes by scraping
    @recipes = Scraper.new(current_user.id).search(@params["food"])
    # get all the recipes that were just saved to the temp table
    erb :'/recipe/search_results'
  end

  get '/users/:user_name/recipes/new/:id' do 
    @recipe = TempRecipe.find_by(id: params[:id])
    # raise @recipe.inspect
    erb :"recipe/see_recipe"
  end
 
  get '/users/:user_name/recipes/:id' do
    @session = session
    @recipe = Recipe.where("id = #{params[:id]}")
    erb :'/recipe/see_my_recipe'
  end

  post '/users/:user_name/recipes/new/:id' do
    "I am a new Recipe #{params[:id]}"
    # get the indicated (id) recipe from temp_recipe database
    # and save it into the user's recipes
  end

end