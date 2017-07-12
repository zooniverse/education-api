class AddProjectsKeyToClassrooms < ActiveRecord::Migration[5.1]
  def change
    add_reference :classrooms, :projects, foreign_key: true
  end
end
