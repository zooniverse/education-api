class User < ActiveRecord::Base
  def self.from_panoptes(hash)
    user_id = hash.fetch("id")

    User.find_or_create_by(zooniverse_id: user_id)
  end
end
