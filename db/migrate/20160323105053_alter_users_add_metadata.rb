class AlterUsersAddMetadata < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :metadata, :jsonb
  end
end
