module Classrooms
  class Index < Operation
    def execute
      # TODO: Scope to current user
      Classroom.all
    end
  end
end
