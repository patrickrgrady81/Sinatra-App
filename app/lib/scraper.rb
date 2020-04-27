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
        doc = Nokogiri::HTML(open(recipe.href).read)
        scrape_for_ingredients(doc, recipe)
        scrape_for_directions(doc, recipe)
        recipe.save
    end

    def scrape_for_ingredients(doc, recipe)
        recipe.ingredients = doc.css("span.recipe-ingred_txt, span.ingredients-item-name").map do |el|
            el.text.strip
        end

    end

    def scrape_for_directions(doc, recipe)
        directions = doc.css("ol.list-numbers.recipe-directions__list li, li.instructions-section-item p").map{|direction|
            direction.text.strip
        }
        recipe.directions = directions
    end

end