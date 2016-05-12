module Classrooms
  class TeacherIndex < Operation
    def execute
      # panoptes_groups = panoptes.paginate("/user_groups", {})
      # panoptes_ids = panoptes_groups.fetch("user_groups").map {|group| group["id"] }

      current_user.taught_classrooms.where(zooniverse_group_id: panoptes_ids).includes(student_users: [:user])
    end
  end
end
