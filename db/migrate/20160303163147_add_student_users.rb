class AddStudentUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :student_users do |t|
      t.references :classroom
      t.references :user
    end
  end
end
