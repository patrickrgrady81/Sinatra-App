
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
    erb :"recipe/see_recipe"
  end

  post '/users/:user_name/recipes/new/:id' do
    @current_user = current_user
    # get the indicated (id) recipe from temp_recipe database using params[:id]
    temp_recipe = TempRecipe.find_by(id: params[:id])
    # and save it into the user's recipes using @current_user.id
    recipe = Recipe.find_or_create_by({name: temp_recipe.name, href: temp_recipe.href, rating: temp_recipe.rating, description: temp_recipe.description, user_id: @current_user.id})
    # save all the ingredients
    ingredients = to_array(temp_recipe.ingredients)
    ingredients.each do |ing|
      # Save ingredient to db
      Ingredient.create(ingredient: ing, recipe_id: recipe.id)
    end
    # save all the directions
    directions = to_array(temp_recipe.directions)
    directions.each do |dir|
      # Save direction to db
      Direction.create(direction: dir, recipe_id: recipe.id)
    end
    redirect :"/users/#{get_user_name}"
  end
 
  get '/users/:user_name/recipes/:id' do
    @recipe = Recipe.where("id = #{params[:id]}")
    @recipe = @recipe[0]
    # get ingredients from ingredient table
    @ingredients = Ingredient.where("recipe_id = #{@recipe.id}")
    
    # get directions from direction table
    @directions = Direction.where("recipe_id = #{@recipe.id}")
    erb :'/recipe/see_my_recipe'
  end

  get '/users/:user_name/edit/:recipe_name' do 
    # find the recipe by recipe name in db
    @recipe = Recipe.find_by(name: params[:recipe_name])
    # get ingredients from ingredient table
    @ing = Ingredient.where(:recipe_id => @recipe.id).to_json
    # get directions from direction table
    @dir = Direction.where(:recipe_id => @recipe.id).to_json
    erb :'/recipe/edit'
  end

  post '/users/:user_name/new' do
    recipe = Recipe.find_or_create_by({name: params[:name], href: nil, rating: params[:rating], description: params[:description], user_id: get_user_id})
    
    ingredients = pretty_save(params[:ingredients])
    ingredients.each do |ing|
      # Save ingredient to db
      recipe.ingredients.create(ingredient: ing)
    end
    # save all the directions
    directions = pretty_save(params[:directions])
    directions.each do |dir|
      # Save direction to db
      recipe.diretions.create(direction: dir)
    end


    redirect to "/users/#{get_user_name}"
  end

  patch '/users/:user_name/recipes/:id' do 
    raise params.inspect
    recipe = Recipe.find_by(name: params[:name])
    recipe.update(name: recipe.name, description: recipe.description, rating: recipe.rating)
    recipe = Recipe.find_by(name: params[:name])
    
    redirect to "/users/#{get_user_name}/recipes/#{recipe.id}"
  end

  delete '/users/:user_name/recipes/:id' do 
    #delete from db
    r  = Recipe.find(params[:id])
    id = r.id 
    r.destroy if r.user == current_user
    Ingredient.where(:recipe_id => id ).destroy_all
    Direction.where(:recipe_id => id ).destroy_all
    
    redirect to '/users/:user_name'
  end

end