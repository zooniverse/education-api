class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.string :name, null: false
      t.jsonb :metadata

      t.string :workflow_id, null: false
      t.string :subject_set_id, null: false
      t.references :classroom, null: false

      t.timestamps null: false
      t.timestamp :deleted_at
    end

    add_foreign_key :assignments, :classrooms
  end
end
