class ApplicationController < Sinatra::Base
  configure do
  	set :views, "app/views"
    set :public_dir, "public" 

    enable :sessions
    set :session_secret, "reverb_secret"
  end

  get "/" do
    logout
    @session = session
  	erb :index
  end

  get "/users/login" do 
    @session = session 
    @session[:type] = "login"
    erb :login
  end

  get "/users/new" do 
    @session = session
    @session[:type] = "signup"
    @session[:error] ||= ""
    erb :new_user
  end

  post "/users" do 
    @session = session
    if @session[:type] == "signup"
      @session[:input_email] = params[:user_email]
      # make sure user_password == confirm_password
        if params[:user_password] != params[:confirm_password]
          @session[:error] = "Your passwords must match"
          redirect "/users/new"
        end
      # check to see if password is properly formatted using regex
      # check db if email is taken
      # maybe check to see password is in a certain format
      # if everything is ok, add this new user to the db
      #     set the session to the users email
      # if not redirect to '/users/new' with an error message

      @session[:error] = "Sorry can't log in right now"
      redirect "/users/new"

    else  #@session[:type] == "login"
      # check if email is in db
      # if no, error = "Invalid username or password"
      # if yes, check to make sure password is correct
      # if no, error = "Invalid username or password"
      # if yes, set session[:email] to user email, user is now logged in
    end
  end

  helpers do 
    def logout
      session.clear
    end
  end
end