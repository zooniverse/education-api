module Classrooms
  class TeacherCreate < Operation
    string :name

    validates :name, presence: true

    def execute
      Classroom.create!(name: name).tap do |classroom|
        panoptes_group = panoptes.post("/user_groups", user_groups: {name: SecureRandom.uuid})["user_groups"][0]
        classroom.update_columns zooniverse_group_id: panoptes_group.fetch("id"),
                                 join_token: panoptes_group.fetch("join_token")
      end
    end
  end
end
