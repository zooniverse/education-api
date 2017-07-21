class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :slug, null: false
      t.boolean :custom_subject_set, default: false
      t.index :slug, unique: true
    end
  end
end
