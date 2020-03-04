class CreateTempRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :temp_recipes do |t|
      t.string :name
      t.string :href
      t.decimal :rating
      t.text :description
      t.text :ingredients
      t.text :directions
      t.references :user
    end
  end
end
