class RemoveAssignmentSubjectIdNullContraint < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:assignments, :subject_set_id, true)
  end
end
