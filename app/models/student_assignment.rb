class StudentAssignment < ActiveRecord::Base
  belongs_to :student_user
  belongs_to :assignment
end
