module Classrooms
  class TeacherCreate < Operation
    hash :attributes do
      string :name
      string :school, default: nil
      string :subject, default: nil
      string :description, default: nil
    end

    relationships do
      belongs_to :program
    end

    def execute
      classroom = program.classrooms.create!(
        name: attributes[:name],
        teachers: [current_user]
      )
      classroom.school = attributes[:school] if attributes[:school]
      classroom.subject = attributes[:subject] if attributes[:subject]
      classroom.description = attributes[:description] if attributes[:description]
      join_group(classroom)
    end

    def program
      @program ||= Program.find(program_id)
    end

    def join_group(classroom)
      panoptes_group = client.panoptes.post("/user_groups", user_groups: {name: SecureRandom.uuid})["user_groups"][0]
      classroom.update_columns zooniverse_group_id: panoptes_group.fetch("id"),
                               join_token: panoptes_group.fetch("join_token")
      classroom
    end
  end
end
