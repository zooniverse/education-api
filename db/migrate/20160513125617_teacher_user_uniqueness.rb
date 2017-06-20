class TeacherUserUniqueness < ActiveRecord::Migration[4.2]
  def change
    add_index :teacher_users, [:classroom_id, :user_id], unique: true
  end
end
