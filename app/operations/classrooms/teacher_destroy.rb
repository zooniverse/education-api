module Classrooms
  class TeacherDestroy < Operation
    integer :id

    def execute
      classroom = current_user.taught_classrooms.active.find(id)

      panoptes.delete_user_group(classroom.zooniverse_group_id)

      classroom.update! deleted_at: Time.now
    end
  end
end
