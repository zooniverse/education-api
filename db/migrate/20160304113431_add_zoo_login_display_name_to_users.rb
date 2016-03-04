class AddZooLoginDisplayNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zooniverse_login, :string
    add_column :users, :zooniverse_display_name, :string
  end
end
