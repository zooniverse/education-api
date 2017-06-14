class ApplyUniqueIndexForUsers < ActiveRecord::Migration[5.1]
  def change
    add_index(:users, :zooniverse_id, unique: true)
  end
end
