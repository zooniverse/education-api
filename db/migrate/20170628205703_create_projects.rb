class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :slug, null: false
      t.integer :base_workflow_id, null: true, default: nil
      t.index :slug, unique: true
    end
  end
end
