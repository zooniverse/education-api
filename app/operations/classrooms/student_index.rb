module Classrooms
  class StudentIndex < Operation
    def execute
      current_user.studied_classrooms.active.includes(student_users: [:user])
    end
  end
end
