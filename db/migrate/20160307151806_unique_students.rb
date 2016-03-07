class UniqueStudents < ActiveRecord::Migration
  def change
    add_index :student_users, [:classroom_id, :user_id], unique: true
  end
end
