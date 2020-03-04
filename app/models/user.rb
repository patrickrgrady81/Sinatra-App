class User < ActiveRecord::Base
  has_many :recipes
  has_many :temp_recipes
  has_secure_password

  validates :user_name, :presence => true, 
  :uniqueness => true
  validates :email,    :presence => true,
    :uniqueness => true
  validates :password, :presence => true
    
end