class Project < ActiveRecord::Base
  has_many :classrooms

  validates :slug, presence: true
end
