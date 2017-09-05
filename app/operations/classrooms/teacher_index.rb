module Classrooms
  class TeacherIndex < Operation
    integer :program_id, default: nil

    def execute
      classrooms = current_user.taught_classrooms.active.includes(student_users: [:user])
      classrooms = classrooms.where(program_id: program_id)
    end
  end
end
