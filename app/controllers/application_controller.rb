class ApplicationController < Sinatra::Base
  configure do
  	set :views, "app/views"
    set :public_dir, "public" 

    enable :sessions
    set :session_secret, "reverb_secret"
  end

  get "/" do
    @session = session
    @session[:input_email] ||= ""
  	erb :index
  end

  get "/users/new" do 
    @session = session
    @session[:error] ||= ""
    erb :new_user
  end

  post "/users" do 
    @session = session
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

    @session[:error] = "Sorry wrong info"
    redirect "/users/new"
  end
end