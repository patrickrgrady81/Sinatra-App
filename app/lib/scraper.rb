require 'open-uri'
require 'nokogiri'

class Scraper
    attr_accessor :food, :page, :user_id, :debug, :current_recipe

    def initialize(user_id)
        @page = 1
        @user_id = user_id
    end

    def search(food)
        @food = food
        scrape_for_recipes
    end

    def get_page
        #https://www.allrecipes.com/search/results/?wt=apples&sort=re&page=1
        Nokogiri::HTML(open("https://www.allrecipes.com/search/results/?wt=#{@food}&sort=re&page=#{@page}").read)
    end

    def scrape_for_recipes
        doc = get_page
        recipes = doc.css("div.fixed-recipe-card__info")
        recipes.collect{|recipe|
            name = recipe.css("span.fixed-recipe-card__title-link").text
            href = recipe.css("h3.fixed-recipe-card__h3 a").attribute("href").value
            rating = recipe.css("div.fixed-recipe-card__ratings span.stars").attribute("aria-label").text
            description = recipe.css("div.fixed-recipe-card__description").text
            TempRecipe.create({name: name, href: href, rating: rating, description: description, user_id: user_id})
        }
    end

    def update_recipe(recipe)
        # get which recipe to update from the db
        doc = Nokogiri::HTML(open(recipe.href).read)
        scrape_for_ingredients(doc, recipe)
        scrape_for_directions(doc, recipe)
        recipe.save
    end

    def scrape_for_ingredients(doc, recipe)
        
        index = 1
        # while doc.css("ul#lst_ingredients_" + index.to_s).count > 0 do
        #     doc.css("ul#lst_ingredients_" + index.to_s + " li").each{|ing|
        #         ingredients << ing.inner_text.strip.to_s
        #     }
        #     index += 1
        # end

        recipe.ingredients = doc.css("span.recipe-ingred_txt, span.ingredients-item-name").map do |el|
            el.text.strip
        end

    end

    def scrape_for_directions(doc, recipe)
        directions = doc.css("ol.list-numbers.recipe-directions__list li, li.instructions-section-item p").map{|direction|
            direction.text.strip
        }
        
        # Save directions to db
        recipe.directions = directions
    end
end