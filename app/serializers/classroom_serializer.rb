class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :join_token

  has_many :groups
  has_many :students, serializer: UserSerializer
end
