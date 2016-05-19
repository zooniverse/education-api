class AddDeletedAtToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :deleted_at, :datetime
  end
end
