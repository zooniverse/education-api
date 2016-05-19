module StudentUsers
  class Destroy < Operation
    integer :classroom_id
    integer :id

    def execute
      classroom = current_user.taught_classrooms.find(classroom_id)
      student_user = classroom.student_users.find(id)

      StudentUser.transaction do
        student_user.destroy!
        panoptes.remove_user_from_user_group(classroom.zooniverse_group_id, student_user.zooniverse_id)
      end
    end
  end
end
