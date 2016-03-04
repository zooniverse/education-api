class AddClassroomMetadata < ActiveRecord::Migration
  def change
    add_column :classrooms, :school, :string
    add_column :classrooms, :subject, :string
    add_column :classrooms, :description, :text
  end
end
