class StudentUser < ActiveRecord::Base
  belongs_to :classroom
  belongs_to :user

  has_many :student_assignments
  has_many :assignments, through: :student_assignments

  delegate :zooniverse_id, :zooniverse_login, :zooniverse_display_name, to: :user
end
