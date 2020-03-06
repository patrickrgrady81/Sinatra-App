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
    Scraper.new(user_id: current_user.id).search(food: @params["food"])
    session["recipes"]= LocalRecipe.all
    @session = session 
    erb :'/recipe/search_results'
  end

  get '/users/:user_name/recipes/new/:id' do 
    all_recipes = LocalRecipe.all
    scraper = Scraper.new(user_name: session["user"], food: nil).update_recipe(params[:id])
    binding.pry
    erb :"recipe/see_recipe"
  end
 
  get '/users/:user_name/recipes/:id' do
    @session = session
    @recipe = Recipe.where("id = #{params[:id]}")
    erb :'/recipe/see_my_recipe'
  end
end