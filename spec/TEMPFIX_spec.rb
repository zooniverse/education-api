require "spec_helper"

RSpec.describe "duplicate users" do

  it "fixes duplicate users" do
    user1 = User.create(zooniverse_id: 666)
    user2 = User.create(zooniverse_id: 666)
    
    studentUser1 = StudentUser.create(user: user1)
    studentUser2 = StudentUser.create(user: user2)
    
    merge_duplicate_users()
    
    expect(User.count).to eq(1)
    expect(User.first.student_users.count).to eq(2)
    
  end
end

def merge_duplicate_users()
  list_of_ids = User.group("zooniverse_id").having("count(*) > 1").pluck(:zooniverse_id)
  list_of_ids.each do |id|
    users = User.where(zooniverse_id: id).order("updated_at DESC")
    
    original_id = users[0].id
    
    users[1..-1].each do |the_duplicate|
      StudentUser.where(user_id: the_duplicate.id).update_all(user_id: original_id)
      TeacherUser.where(user_id: the_duplicate.id).update_all(user_id: original_id)
      the_duplicate.destroy()
    end
    
  end
end
