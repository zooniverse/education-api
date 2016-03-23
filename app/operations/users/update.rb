module Users
  class Update < Operation
    string :id
    hash :metadata, strip: false, default: {}

    validates :id, presence: true

    def execute
      user = User.find_by! zooniverse_id: id
      user.update! metadata: metadata
      user
    end
  end
end
