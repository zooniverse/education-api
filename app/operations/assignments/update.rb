module Assignments
  class Update < Operation
    integer :id
    string :name, default: nil
    hash :metadata, strip: false, default: nil

    def execute
      classroom_ids = current_user.taught_classrooms.active.pluck(:id)

      Assignment.active.where(classroom_id: classroom_ids).find(id).tap do |assignment|
        assignment.name = name unless name.blank?
        assignment.metadata = metadata unless metadata.nil?
        assignment.save!
      end
    end
  end
end
