class UserSerializer < ActiveModel::Serializer
  attributes :id, :zooniverse_id, :zooniverse_login, :zooniverse_display_name, :metadata
end
