module Classrooms
  class StudentIndex < Operation
    def execute
      # panoptes_groups = panoptes.paginate("/user_groups", {})
      # panoptes_ids = panoptes_groups.fetch("user_groups").map {|group| group["id"] }

      current_user.studied_classrooms.includes(student_users: [:user])
    end
  end
end
