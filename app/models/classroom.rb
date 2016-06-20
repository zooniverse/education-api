class Classroom < ActiveRecord::Base
  include Deletable

  has_many :student_users
  has_many :students, through: :student_users, source: :user
  has_many :teacher_users
  has_many :teachers, through: :teacher_users, source: :user

  has_many :assignments
  has_many :groups

  def taught_by?(user)
    teacher_users.where(user: user).any?
  end
end
