module Classrooms
  class TeacherShow < Operation
    integer :id

    def execute
      Classroom.find(id)
    end
  end
end
