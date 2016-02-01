module Classrooms
  class StudentShow < Operation
    integer :id

    def execute
      Classroom.find(id)
    end
  end
end
