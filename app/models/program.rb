class Program < ActiveRecord::Base
  has_many :classrooms
  has_many :projects

  validates :slug, presence: true
end
