module Classrooms
  class Create < Operation
    string :name

    validates :name, presence: true

    def execute
      Classroom.create!(name: name).tap do |classroom|
        # TODO: Take API token from current user, and create a group on Panoptes
      end
    end
  end
end
