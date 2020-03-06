class ChangeRecipeRatingFromDeimalToString < ActiveRecord::Migration[5.2]
  def change
    change_column :temp_recipes, :rating, :string
  end
end
