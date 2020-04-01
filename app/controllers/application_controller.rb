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

    def get_display_name
      current_user.display_name
    end

    def get_user_email
      current_user.email
    end

    def get_user_name 
      session[:user][:user_name]
    end

    def to_array(str)
      # remove all " and all [] 

      s1 = str.gsub("[", '')
      s2 = s1.gsub(/^\"/, '')
      s3 = s2.gsub("\"", '*')
      s4 = s3.gsub("]", '')
      s5 = s4.gsub("Add all ingredients to list", "")
      a = s5.split("*")
      collection = a.collect do |a2|
        if a2 == ", " || a2 == ""
          a2 = nil
        else
          a2
        end
      end
      # binding.pry
      collection.compact
    end

    def pretty_save(str)
    str = str.gsub(/\r/,",")
    str = str.gsub(/\n/,"") 
    # gsub "1. " out
    str = str.gsub(/\d{1}\.\s/, "")
    # gsub "<br>" out
    str = str.gsub(/<br>/, "")
    str = str.split(",")
    str = str.collect do |s|
      s.strip
    end
    str = str.collect do |s|
      s if s != ""
    end
    str = str.compact 
    end
  end
end