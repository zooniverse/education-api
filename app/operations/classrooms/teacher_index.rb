module Classrooms
  class TeacherIndex < Operation
    integer :program_id

    def execute
      current_user.taught_classrooms
        .active
        .includes(student_users: [:user])
        .where(program_id: program_id)
    end
  end
end
