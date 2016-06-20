class StudentAssignment < ActiveRecord::Base
  belongs_to :student, class_name: 'StudentUser', foreign_key: 'student_user_id'
  belongs_to :assignment
end
