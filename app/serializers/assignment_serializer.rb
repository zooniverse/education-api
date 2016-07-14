class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :metadata, :workflow_id, :subject_set_id
  has_many :student_assignments
  has_many :student_users
end
