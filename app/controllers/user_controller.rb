class UserController < ApplicationController
  
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

  get '/users/:user_name/change_display' do 
    erb :'/user/change_display'
  end

  post '/change_display' do 
    if current_user.authenticate(params[:password])
      current_user.update(display_name: params[:display_name], password: params[:password])
      redirect to '/users/:user_name'
    else
      @error = "Incorrect Password"
      erb :'/user/change_display'
    end
  end

  get '/users/:user_name/change_password' do 
    erb :'/user/change_password'
  end

  post '/change_password' do 
    if current_user.authenticate(params[:current_password])
      current_user.update(password: params[:new_password])
      redirect to '/users/:user_name'
    else
      @error = "Incorrect Password"
      erb :'/user/change_password'
    end
  end
end