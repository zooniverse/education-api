module Programs
  class Show < ActiveInteraction::Base
    integer :id
    validates :id, presence: true

    def execute
      Program.find(id)
    end
  end
end
