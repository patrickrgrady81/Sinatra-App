class AddDisplayNameToUsers < ActiveRecord::Migration[5.2]
   def change
      add_column :users, :display_name, :text
   end
end
