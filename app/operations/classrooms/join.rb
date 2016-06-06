module Classrooms
  class Join < Operation
    integer :id
    string  :join_token

    validates :id, presence: true
    validates :join_token, presence: true

    def execute
      classroom = Classroom.active.find_by!(id: id, join_token: join_token)
      response = join_panoptes_group(classroom)

      if response
        classroom.students << current_user
      else
        errors.add(:id, "cannot join")
      end

      classroom
    end



    def join_panoptes_group(classroom)
      return true if classroom.taught_by?(current_user)
      panoptes.join_user_group(classroom.zooniverse_group_id, current_user.zooniverse_id, join_token: classroom.join_token)
    rescue Panoptes::Client::ServerError
      false
    end
  end
end
