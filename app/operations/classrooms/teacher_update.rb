module Classrooms
  class TeacherUpdate < Operation
    integer :id

    string :name
    string :school, default: nil
    string :subject, default: nil
    string :description, default: nil

    validates :name, presence: true

    relationships do
      belongs_to :program
    end

    def execute
      classroom = current_user.taught_classrooms.active.find(id)
      classroom.update!(name: name, school: school, subject: subject, description: description)
      classroom
    end
  end
end
