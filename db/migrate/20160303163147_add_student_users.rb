class AddStudentUsers < ActiveRecord::Migration
  def change
    create_table :student_users do |t|
      t.references :classroom
      t.references :user
    end
  end
end
