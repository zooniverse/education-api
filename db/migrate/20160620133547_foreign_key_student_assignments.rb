class ForeignKeyStudentAssignments < ActiveRecord::Migration
  def change
    add_foreign_key :student_assignments, :student_users, on_update: :cascade, on_delete: :cascade
    add_foreign_key :student_assignments, :assignments, on_update: :cascade, on_delete: :cascade
  end
end
