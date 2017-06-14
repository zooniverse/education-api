class AddClassroomMetadata < ActiveRecord::Migration[5.1]
  def change
    add_column :classrooms, :school, :string
    add_column :classrooms, :subject, :string
    add_column :classrooms, :description, :text
  end
end
