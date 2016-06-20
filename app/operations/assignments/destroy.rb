module Assignments
  class Destroy < Operation
    integer :id

    def execute
      classroom_ids = current_user.taught_classrooms.active.pluck(:id)
      assignment = Assignment.active.where(classroom_id: classroom_ids).find(id)
      assignment.update! deleted_at: Time.now
      assignment
    end
  end
end
