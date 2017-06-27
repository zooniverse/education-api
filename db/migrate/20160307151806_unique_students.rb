class UniqueStudents < ActiveRecord::Migration[4.2]
  def change
    add_index :student_users, [:classroom_id, :user_id], unique: true
  end
end
