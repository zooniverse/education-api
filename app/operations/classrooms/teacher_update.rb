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
      classroom.name = name if name
      classroom.school = school if school
      classroom.subject = subject if subject
      classroom.description = description if description
      classroom.save!
      classroom
    end
  end
end
