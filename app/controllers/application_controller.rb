class ApplicationController < Sinatra::Base
  configure do
  	set :views, "app/views"
    set :public_dir, "public" 
    set :views, Proc.new { File.join(root, "../views/") }

    enable :sessions
    set :session_secret, "reverb_secret"
  end

  get "/" do
    @session = session
  	erb :'/user/index'
  end

  get "/users/login" do 
    @session = session 
    @session[:type] = "login"
    erb :'/user/login'
  end

  get "/users/logout" do 
    logout 
    redirect "/"
  end

  get "/users/new" do 
    @session = session
    @session[:type] = "signup"
    @session[:error] ||= ""
    erb :'/user/new_user'
  end

  post "/users" do 
    @session = session
    if @session[:type] == "signup"
      # @session[:input_email] = params[:user_email]
      # make sure user_password == confirm_password
        if params[:user_password] != params[:confirm_password]
          @session[:error] = "Your passwords must match."
          redirect "/users/new"
        end

      email = params[:user_email].downcase
      user = params[:user_name].downcase
      password = params[:user_password]
      # check if email is valid 
      # using email_address gem
      # use easy_email = true if you want to create accounts without validating the email
      # this will make it easier to create accounts by allowing any fake email
      easy_emails = true 
      if !easy_emails
        if !EmailAddress.valid?(email)
          @session[:error] = EmailAddress.error(email)
          redirect '/users/new'
        end
      end

      # check db if email is taken
      if @user = User.find_by(email: email)
        @session[:error] = "Sorry, that email already has an account."
        redirect '/users/new'
      end
      # check to see if user_name is taken
      if @user = User.find_by(user_name: user)
        @session[:error] = "Sorry, that user name is taken."
        redirect '/users/new'
      end
      # user name should be at least 3 characters
      if !user.length > 3
        @session[:error] = "User name must be at least 3 characters long."
        redirect '/users/new'
      end
      # maybe check to see password is in a certain format (1 upper, 1 lower, 1 number, at least 8 chars long, etc.)
      re = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})/
      if re.match(password) == nil
        @session[:error] = "Password must contain 1 upper case, 1 lower case, 1 number, 1 special character (@#$%^&), and must be 8 characters."
        redirect '/users/new'
      end
      # if everything is ok, add this new user to the db
      #     set the session to the users email
      # if not redirect to '/users/new' with an error message

      User.create(email: email, user_name: user, password: password)
      @session[:user] = user
      @session[:error] = nil
      @session[:type] = nil
      redirect "/users/#{@session[:user]}"

    else  #@session[:type] == "login"
      login = params[:login]
      password = params[:user_password]
      user = User.find_by(user_name: login)
      user ||= User.find_by(email: login)

      if user && user.authenticate(password)
        @session[:user] = user.user_name
        @session[:error] = nil
        @session[:type] = nil
        redirect "/users/#{user.user_name}"
      else
        @session[:error] = "Invalid user name or password"
        redirect "/users/login"
      end
      # check if user_name or email is in db
      # if no, error = "Invalid username or password"
      # if yes, check to make sure password is correct
      # if no, error = "Invalid username or password"
      # if yes, set session[:email] to user email, user is now logged in
    end
  end

  get '/users/:user_name' do 
    if logged_in?
      @session = session
      # get a list of all the user's recipes
      @recipes = Recipe.where("user = #{get_user_id}")
      # raise @recipes.inspect
      erb :"/user/user_profile"
    else
      redirect "/"
    end
  end

  helpers do 
    def logged_in?
      return false if !session[:user]
      true
    end

    def logout
      session.clear
    end

    def get_user_id
      user = User.find_by(user_name: session[:user])
      user.id
    end
  end
end