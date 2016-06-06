module Classrooms
  class Join < Operation
    integer :id
    string  :join_token

    validates :id, presence: true
    validates :join_token, presence: true

    def execute
      classroom = Classroom.active.find_by!(id: id, join_token: join_token)
      if response = panoptes.join_user_group(classroom.zooniverse_group_id,
                                             current_user.zooniverse_id,
                                             join_token: classroom.join_token)
        classroom.students << current_user
      end
      classroom
    end
  end
end
