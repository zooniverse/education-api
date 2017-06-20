class AddStudentAssignmentClassificationsCount < ActiveRecord::Migration[4.2]
  def change
    add_column :student_assignments, :classifications_count, :integer, default: 0
  end
end
