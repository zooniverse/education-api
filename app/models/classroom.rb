class Classroom < ActiveRecord::Base
  has_many :student_users
  has_many :students, through: :student_users, source: :user
  has_many :groups
end
