module Classrooms
  class Create < Operation
    string :name

    validates :name, presence: true

    def execute
      classroom = Classroom.new(name: name)
      classroom.save!
      classroom
    end
  end
end
