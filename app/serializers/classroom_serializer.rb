class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :join_token, :school, :subject, :description, :classifications_count, :zooniverse_group_id

  has_many :groups
  has_many :student_users, key: :students, serializer: StudentUserSerializer
end
