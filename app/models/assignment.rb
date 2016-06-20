class Assignment < ActiveRecord::Base
  belongs_to :classroom

  has_many :student_assignments
  has_many :students, through: :student_assignments

  validates :classroom, presence: true
  validates :workflow_id, presence: true
  validates :subject_set_id, presence: true

  scope :active, -> { where(deleted_at: nil) }
end
