module Classrooms
  class StudentShow < Operation
    integer :id
    string  :join_token

    def execute
      Classroom.active.find_by(id: id, join_token: join_token)
    end
  end
end
