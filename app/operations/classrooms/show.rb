module Classrooms
  class Show < Operation
    integer :id

    def execute
      Classroom.find(id)
    end
  end
end
