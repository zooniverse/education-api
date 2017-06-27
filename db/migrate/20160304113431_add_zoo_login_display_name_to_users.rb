class AddZooLoginDisplayNameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :zooniverse_login, :string
    add_column :users, :zooniverse_display_name, :string
  end
end
