class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients
  has_many :directions

  validates :name, :presence => true, :uniqueness => true
end