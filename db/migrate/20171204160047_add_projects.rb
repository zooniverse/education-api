class AddProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.references :program
    end
  end
end
