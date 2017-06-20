class CreateAssignedStudents < ActiveRecord::Migration[4.2]
  def change
    create_table :student_assignments do |t|
      t.references :assignment
      t.references :student_user
    end
  end
end
