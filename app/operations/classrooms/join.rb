module Classrooms
  class Join < Operation
    integer :id
    string  :join_token

    validates :name, presence: true

    def execute
      classroom = Classroom.find_by!(id: id, join_token: join_token)
      response = panoptes.join_user_group(classroom.zooniverse_group_id,
                                          current_user.zooniverse_id,
                                          join_token: classroom.join_token)
    end
  end
end
