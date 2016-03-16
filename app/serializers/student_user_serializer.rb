class StudentUserSerializer < ActiveModel::Serializer
  attributes :id, :zooniverse_id, :zooniverse_login, :zooniverse_display_name, :classifications_count
end
