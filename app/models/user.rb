class User < ActiveRecord::Base
  has_many :student_users
  has_many :studied_classrooms, through: :student_users

  has_many :teacher_users
  has_many :taught_classrooms, through: :teacher_users

  def self.from_panoptes(hash)
    user_id = hash.fetch("id")

    user = User.find_or_create_by(zooniverse_id: user_id)
    user.zooniverse_login = hash.fetch("login")
    user.zooniverse_display_name = hash.fetch("display_name")
    user.save! if user.changed?
    user
  end
end
