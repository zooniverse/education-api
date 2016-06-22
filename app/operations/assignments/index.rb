module Assignments
  class Index < Operation
    integer :classroom_id, default: nil

    def execute
      assignments_from_taught_classrooms | assignments_for_user_as_a_student
    end

    def assignments_from_taught_classrooms
      classroom_ids = filter_classrooms(current_user.taught_classrooms).pluck(:id)
      Assignment.active.where(classroom_id: classroom_ids).load
    end

    def assignments_for_user_as_a_student
      classroom_ids = filter_classrooms(current_user.studied_classrooms).pluck(:id)
      student_user_ids = current_user.student_users.pluck(:id)
      Assignment.active.joins(:student_users).where(classroom_id: classroom_ids, student_users: {id: student_user_ids}).load
    end

    def filter_classrooms(classrooms)
      classrooms = classrooms.active
      classrooms = classrooms.where(id: [classroom_id]) if classroom_id
      classrooms
    end
  end
end
