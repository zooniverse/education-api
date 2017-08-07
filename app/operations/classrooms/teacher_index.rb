module Classrooms
  class TeacherIndex < Operation
    def execute
      current_user.taught_classrooms.active.includes(student_users: [:user])
    end
  end
end
