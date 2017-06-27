class AddClassroomMetadata < ActiveRecord::Migration[4.2]
  def change
    add_column :classrooms, :school, :string
    add_column :classrooms, :subject, :string
    add_column :classrooms, :description, :text
  end
end
