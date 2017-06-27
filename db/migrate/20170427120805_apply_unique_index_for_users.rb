class ApplyUniqueIndexForUsers < ActiveRecord::Migration[4.2]
  def change
    add_index(:users, :zooniverse_id, unique: true)
  end
end
