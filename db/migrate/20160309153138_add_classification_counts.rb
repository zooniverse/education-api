class AddClassificationCounts < ActiveRecord::Migration[5.1]
  def change
    add_column :student_users, :classifications_count, :integer, default: 0
    add_column :classrooms,    :classifications_count, :integer, default: 0
  end
end
