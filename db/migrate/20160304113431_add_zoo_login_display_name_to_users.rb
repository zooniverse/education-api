class AddZooLoginDisplayNameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :zooniverse_login, :string
    add_column :users, :zooniverse_display_name, :string
  end
end
