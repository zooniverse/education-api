module Classrooms
  class TeacherShow < Operation
    integer :id
    validates :id, presence: true

    def execute
      Classroom.active.find!(id)
    end
  end
end
