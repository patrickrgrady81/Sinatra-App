require 'open-uri'
require 'nokogiri'

class Scraper
    attr_accessor :food, :page, :user_id, :debug

    def search(food, user_id, page=1)
        @food = food
        @page = page
        @user_id = user_id
        scrape_for_recipes(get_page)
    end

    def get_page
        #https://www.allrecipes.com/search/results/?wt=apples&sort=re&page=1
        Nokogiri::HTML(open("https://www.allrecipes.com/search/results/?wt=#{@food}&sort=re&page=#{@page}").read)
    end

    def scrape_for_recipes(doc)
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
    end

    def scrape_for_ingredients(doc, recipe)
        ingredients = []
        index = 1
        while doc.css("ul#lst_ingredients_" + index.to_s).count > 0 do
            doc.css("ul#lst_ingredients_" + index.to_s + " li").each{|ing|
                ingredients << ing.inner_text.strip.to_s
            }
            index += 1
        end
        recipe.ingredients = ingredients[0...-1]
    end

    def scrape_for_directions(doc, recipe)
        directions = doc.css("ol.list-numbers.recipe-directions__list li").map{|direction|
            direction.text.strip
        }
        recipe.directions = directions
    end
end