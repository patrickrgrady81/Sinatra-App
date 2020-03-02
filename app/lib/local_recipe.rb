class LocalRecipe
  attr_accessor :name, :href, :rating, :description, :ingredients, :directions

  @@all = []

  def initialize(name:, href:, description:)
    @name = name
    @href = href 
    @rating = rating 
    @decription = description
    @@all << self
  end

  def self.all  
    @@all
  end
end 