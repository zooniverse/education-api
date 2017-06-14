class AddDeletedAtToClassrooms < ActiveRecord::Migration[5.1]
  def change
    add_column :classrooms, :deleted_at, :datetime
  end
end
