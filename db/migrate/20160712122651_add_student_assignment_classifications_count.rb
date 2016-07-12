class AddStudentAssignmentClassificationsCount < ActiveRecord::Migration
  def change
    add_column :student_assignments, :classifications_count, :integer, default: 0
  end
end
