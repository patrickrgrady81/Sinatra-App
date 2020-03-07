
class RecipeController < ApplicationController

  get '/users/:user_name/recipes/new' do 
    erb :'/recipe/new'
  end

  get '/users/:user_name/recipes/search' do 
    @current_user = current_user
    erb :'/recipe/search_for'
  end

  post "/users/recipes/search" do 
    # get all the temp recipes by scraping
    @recipes = Scraper.new(current_user.id).search(@params["food"])
    erb :'/recipe/search_results'
  end

  get '/users/:user_name/recipes/new/:id' do 
    @recipe = TempRecipe.find_by(id: params[:id])
    Scraper.new(current_user.id).update_recipe(@recipe)
    @ingredients = to_array(@recipe.ingredients)
    @directions = to_array(@recipe.directions)
    # raise @recipe.ingredients.inspect
    erb :"recipe/see_recipe"
  end
 
  get '/users/:user_name/recipes/:id' do
    @recipe = Recipe.where("id = #{params[:id]}")
    @recipe = @recipe[0]
    @ingredients = to_array(@recipe.ingredients)
    @directions = to_array(@recipe.directions)
    erb :'/recipe/see_my_recipe'
  end

  get '/users/:user_name/edit/:recipe_name' do 
    # find the recipe by recipe name in db
    @recipe = Recipe.find_by(name: params[:recipe_name])
    @ingredients = to_array(@recipe.ingredients)
    @directions = to_array(@recipe.directions)
    erb :'/recipe/edit'
  end

  post '/users/:user_name/recipes/new/:id' do
    # "I am a new Recipe #{params[:id]}"
    @current_user = current_user
    # get the indicated (id) recipe from temp_recipe database using params[:id]
    recipe = TempRecipe.find_by(id: params[:id])
    # and save it into the user's recipes using @current_user.id
    r = Recipe.find_or_create_by({name: recipe.name, href: recipe.href, rating: recipe.rating, description: recipe.description, ingredients: recipe.ingredients, directions: recipe.directions, user_id: @current_user.id})
  
    redirect :'/users/:user_name'
  end

  delete '/users/:user_name/recipes/:id' do 
    #delete from db
    # User.find(15).destroy
    # User.destroy(15)
    # User.where(age: 20).destroy_all
    r  = Recipe.find(params[:id])
    r.destroy if r.user == current_user
    
    redirect to '/users/:user_name'
  end

end