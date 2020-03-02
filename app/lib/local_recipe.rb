class LocalRecipe
  attr_accessor :name, :href, :rating, :description, :ingredients, :directions, :id

  @@all = []
  @@current_id = 1

  def initialize(name:, href:, description:)
    @name = name
    @href = href 
    @rating = rating 
    @description = description
    @id = @@current_id
    @@current_id += 1
    @@all << self
  end

  def self.all  
    @@all
  end
end 