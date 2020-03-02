class CreateUserInRecipeTable < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :user, :integer
  end
end
