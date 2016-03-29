module Classrooms
  class StudentIndex < Operation
    def execute
      panoptes_groups = panoptes.paginate("/user_groups", {})
      panoptes_ids = panoptes_groups.fetch("user_groups").map {|group| group["id"] }

      Classroom.where(zooniverse_group_id: panoptes_ids)
    end
  end
end
