class StudentUser < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :user

  delegate :zooniverse_id, :zooniverse_login, :zooniverse_display_name, to: :user
end
