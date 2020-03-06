class LocalRecipe
  attr_accessor :name, :href, :rating, :description, :ingredients, :directions

  def initialize(name:, href:, description:, rating:)
    @name = name
    @href = href
    @rating = rating 
    @description = description
  end

 
end 