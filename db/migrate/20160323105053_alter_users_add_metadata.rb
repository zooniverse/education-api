class AlterUsersAddMetadata < ActiveRecord::Migration
  def change
    add_column :users, :metadata, :jsonb
  end
end
