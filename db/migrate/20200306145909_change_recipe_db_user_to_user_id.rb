class ChangeRecipeDbUserToUserId < ActiveRecord::Migration[5.2]
  def change
    rename_column :recipes, :user, :user_id
  end
end
