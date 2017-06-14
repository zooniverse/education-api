class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :zooniverse_group_id
      t.references :classroom

      t.timestamps null: false
    end
  end
end
