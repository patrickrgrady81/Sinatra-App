class ApplicationController < Sinatra::Base
  configure do
  	set :views, "app/views"
    set :public_dir, "public" 
    set :views, Proc.new { File.join(root, "../views/") }

    enable :sessions
    set :session_secret, "pats_secret"
  end

  get "/" do
    if logged_in?
      redirect "/users/#{get_user_name}"
    end
  	erb :'/user/index'
  end

  get "/users/login" do 
    erb :'/user/login'#, :layout => :layout
  end

  post "/users/login" do 
    user_name = params[:user_name]
    password = params[:user_password]
    user = User.find_by(user_name: user_name)

    if user && user.authenticate(password)
      session[:user] = user
      redirect "/users/#{user.user_name}"
    else
      @error = "Invalid user name or password"
      redirect "/users/login"
    end
  end

  get "/users/logout" do 
    logout 
    redirect "/"
  end

  get "/users/new" do 
    erb :'/user/new_user'
  end

  post '/users/new' do 
    logout
    email = params[:user_email].downcase
    user = params[:user_name].downcase
    password = params[:user_password]

    user = User.create(email: email, user_name: user, password: password)
    if user
      session[:user] = user
      redirect to "/users/#{session[:user][:user_name]}"
    else
      @error = "Username or email taken"
      redirect to "/users/new"
    end

  end

  get '/users/:user_name' do 
    if logged_in?
      # get a list of all the user's recipes
      @current_user = current_user
      @recipes = Recipe.where("user_id = #{@current_user.id}")
      # raise @recipes.inspect
      erb :"/user/user_profile"
    else
      redirect "/"
    end
  end

  get '/users/:user_name/edit/:recipe_name' do 
    # find the recipe by recipe name in db
    @recipe = Recipe.find_by(name: params[:recipe_name])
    erb :'/recipe/edit'
  end

  helpers do
    def logged_in?
      return false if !session[:user]
      true
    end

    def logout
      session.clear
    end

    def current_user
      User.find_by(user_name: get_user_name)
    end

    def get_user_id
      current_user.id
    end

    def get_user_email
      current_user.email
    end

    def get_user_name 
      session[:user][:user_name]
    end
  end
end