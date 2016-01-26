class ClassroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :join_token

  has_many :groups
end
