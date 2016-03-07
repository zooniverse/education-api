class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :join_token, :school, :subject, :description

  has_many :groups
  has_many :students, serializer: UserSerializer
end
