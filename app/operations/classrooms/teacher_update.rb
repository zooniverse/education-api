module Classrooms
  class TeacherUpdate < Operation
    integer :id

    string :name
    string :school, default: nil
    string :subject, default: nil
    string :description, default: nil

    validates :name, presence: true

    def execute
      classroom = current_user.taught_classrooms.find(id)
      classroom.update!(name: name, school: school, subject: subject, description: description)
      classroom
    end
  end
end
