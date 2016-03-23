module Users
  class Show < Operation
    string :id

    validates :id, presence: true

    def execute
      User.find_by! zooniverse_id: id
    end
  end
end
