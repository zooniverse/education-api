class RefactorProjectsToPrograms < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :base_workflow_id, :integer
    remove_column :projects, :slug, :string
    remove_reference :classrooms, :projects, index: true, foreign_key: true

    add_column :projects, :custom, :boolean, null: false, default: false
    add_column :projects, :name, :string, null: false
    add_column :projects, :description, :string
    add_column :projects, :metadata, :jsonb

    rename_table :projects, :programs
    add_reference :classrooms, :programs, index: true, foreign_key: true
  end
end
