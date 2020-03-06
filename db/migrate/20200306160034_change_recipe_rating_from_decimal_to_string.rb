class ChangeRecipeRatingFromDecimalToString < ActiveRecord::Migration[5.2]
  def change
    change_column :recipes, :rating, :string
  end
end
