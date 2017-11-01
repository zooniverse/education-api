module Classrooms
  class Join < Operation
    integer :id
    string  :join_token

    validates :id, presence: true
    validates :join_token, presence: true

    def execute
      response = join_panoptes_group(classroom)

      if response
        classroom.students << current_user
        add_user_to_assignments if !classroom.program.custom?
      else
        errors.add(:id, "cannot join")
      end
      classroom
    end

    def join_panoptes_group(classroom)
      return true if classroom.taught_by?(current_user)
      client.join_user_group(classroom.zooniverse_group_id, current_user.zooniverse_id, join_token: classroom.join_token)
    rescue Panoptes::Client::ServerError
      false
    end

    def add_user_to_assignments
      classroom.assignments.each do |assignment|
        assignment.student_users << student_user
      end
    end

    def classroom
      Classroom.active.find_by!(id: id, join_token: join_token)
    end

    def student_user
      StudentUser.where(user_id: current_user.id, classroom_id: classroom.id).first
    end
  end
end
