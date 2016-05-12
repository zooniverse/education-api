class CreateTeacherUsers < ActiveRecord::Migration
  def change
    create_table :teacher_users do |t|
      t.references :classroom
      t.references :user
    end
  end
end
