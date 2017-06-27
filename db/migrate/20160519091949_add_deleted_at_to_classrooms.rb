class AddDeletedAtToClassrooms < ActiveRecord::Migration[4.2]
  def change
    add_column :classrooms, :deleted_at, :datetime
  end
end
