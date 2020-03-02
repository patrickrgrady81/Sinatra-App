class RecipeController < ApplicationController

  get '/users/:user_name/recipes/new' do 
    erb :'/recipe/new'
  end

  get '/users/:user_name/recipes/search' do 
    @session = session
    erb :'/recipe/search_for'
  end

  post "/users/:user_name/recipes/search" do 
    current_user = User.find_by(user_name: session["user"])
    # get all the temp recipes by scraping
    Scraper.new(@params["food"], user_id: current_user.id)
    # get all the recipes that were just saved to the temp table
    @recipes = TempRecipe.all
    @session = session 
    erb :'/recipe/search_results'
  end

  get "users/:user_name/recipes/delete" do 
    #show the delete all button
    erb :'recipe/delete'
  end

  # delete "users/:user_name/recipes/delete" do 
  #   # actually delete all the data in the TempRecipe table
  #   # TempRecipe.where(id: 0..1000).destroy_all
  #   TempRecipe.delete
  # end



  get '/users/:user_name/recipes/new/:id' do 
    all_recipes = LocalRecipe.all
    raise params.inspect
    erb :"recipe/see_recipe"
  end
 
  get '/users/:user_name/recipes/:id' do
    @session = session
    @recipe = Recipe.where("id = #{params[:id]}")
    erb :'/recipe/see_my_recipe'
  end
end