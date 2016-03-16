require 'csv'

module Classifications
  class ProcessExport < Operation
    filters[:current_user].options[:default] = nil
    integer :project_id

    def execute
      export = panoptes.get("/projects/#{project_id}/classifications_export")
      src    = export.fetch("media")[0].fetch("src")

      #`wget -O #{Rails.root.join("tmp", "classifications_export.csv.gz")} "#{src}"`
      #`gunzip #{Rails.root.join("tmp", "classifications_export.csv.gz")}`

      counts_by_user_group = {}
      counts_by_user = {}

      CSV.foreach(Rails.root.join("tmp", "classifications_export.csv"), headers: true) do |line|
        next unless line["user_id"]

        user_id = line["user_id"]
        counts_by_user[user_id] ||= 0
        counts_by_user[user_id] += 1

        if line["metadata"].include?("user_group_ids")
          metadata = JSON.load(line["metadata"] || "{}")
          user_group_ids = metadata["user_group_ids"] || []
          user_group_ids.each do |user_group_id|
            counts_by_user_group[user_group_id] ||= 0
            counts_by_user_group += 1
          end
        end
      end

      StudentUser.joins(:user).where(users: {zooniverse_id: counts_by_user.keys}).find_each do |student_user|
        student_user.classifications_count = counts_by_user[user.zooniverse_id]
        student_user.save!
      end

      Classroom.where(zooniverse_group_id: counts_by_user_group.keys).find_each do |classroom|
        classroom.classifications_count = counts_by_user_group[classroom.zooniverse_group_id]
        classroom.save!
      end
    end
  end
end
