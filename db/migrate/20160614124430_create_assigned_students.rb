class CreateAssignedStudents < ActiveRecord::Migration
  def change
    create_table :student_assignments do |t|
      t.references :assignment
      t.references :student_user
    end
  end
end
