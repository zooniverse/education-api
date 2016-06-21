module Assignments
  class Update < Operation
    integer :id

    hash :attributes, default: {} do
      string :name, default: nil
      hash :metadata, strip: false, default: nil
    end

    relationships do
      has_many :student_users
    end

    def execute
      classroom_ids = current_user.taught_classrooms.active.pluck(:id)

      Assignment.active.where(classroom_id: classroom_ids).find(id).tap do |assignment|
        assignment.name = attributes[:name] unless attributes[:name].blank?
        assignment.metadata = attributes[:metadata] unless attributes[:metadata].nil?

        if student_user_ids
          assignment.student_users = assignment.classroom.student_users.where(id: student_user_ids)
        end

        assignment.save!
      end
    end
  end
end
