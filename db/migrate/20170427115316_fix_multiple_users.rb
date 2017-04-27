class FixMultipleUsers < ActiveRecord::Migration
  def up
    list_of_ids = User.group("zooniverse_id").having("count(*) > 1").pluck(:zooniverse_id)
    list_of_ids.each do |id|
      users = User.where(zooniverse_id: id).order("updated_at DESC")

      original_user = users[0]
      original_user.metadata ||= {}
      original_id = users[0].id

      users[1..-1].each do |the_duplicate|
        StudentUser.where(user_id: the_duplicate.id).update_all(user_id: original_id)
        TeacherUser.where(user_id: the_duplicate.id).update_all(user_id: original_id)
        
        original_user.metadata["merged_ids"] ||= []
        original_user.metadata["merged_ids"] << the_duplicate.id
        
        the_duplicate.destroy()
      end

      original_user.save()
      
    end
  end
end
