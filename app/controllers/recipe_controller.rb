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
<<<<<<< HEAD
    Scraper.new(user_id: current_user.id).search(food: @params["food"])
    session["recipes"]= LocalRecipe.all
    @session = session 
=======
     #Let's get rid of all previous searches HERE!
    # We need to remove everything from that database
    
    # All the recipes were deleted.. why is the number not back to 1?

    # Get the number back to 1
    # update_seq_sql = "update sqlite_sequence set seq = 0 where name = 'temp_recipes';"


    # get all the temp recipes by scraping
    @recipes = Scraper.new.search(@params["food"], current_user.id)
    # get all the recipes that were just saved to the temp table
>>>>>>> testing_temp_recipe_db
    erb :'/recipe/search_results'
  end

  get '/users/:user_name/recipes/new/:id' do 
<<<<<<< HEAD
    all_recipes = LocalRecipe.all
    scraper = Scraper.new(user_name: session["user"], food: nil).update_recipe(params[:id])
    binding.pry
=======
    @recipe = TempRecipe.find_by(id: params[:id])
    # raise @recipe.inspect
>>>>>>> testing_temp_recipe_db
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