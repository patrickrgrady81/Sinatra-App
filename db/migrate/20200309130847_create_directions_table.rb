class CreateDirectionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :directions do |t|
      t.text :direction 
      t.integer :recipe_id
    end
  end
end
