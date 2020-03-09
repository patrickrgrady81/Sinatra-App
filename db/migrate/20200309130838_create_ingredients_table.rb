class CreateIngredientsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.text :ingredient 
      t.integer :recipe_id
    end
  end
end
