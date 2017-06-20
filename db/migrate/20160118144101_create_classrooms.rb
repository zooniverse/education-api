class CreateClassrooms < ActiveRecord::Migration[4.2]
  def change
    create_table :classrooms do |t|
      t.string :name
      t.integer :zooniverse_group_id
      t.string :join_token

      t.timestamps null: false
    end
  end
end
