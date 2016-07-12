class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :name, :metadata
  has_many :student_assignments
  has_many :student_users
end
