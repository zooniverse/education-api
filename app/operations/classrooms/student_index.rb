module Classrooms
  class StudentIndex < Operation
    integer :program_id

    def execute
      current_user.studied_classrooms
        .active
        .includes(student_users: [:user])
        .where(program_id: program_id)
    end
  end
end
