class AddStudentUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :student_users do |t|
      t.references :classroom
      t.references :user
    end
  end
end
