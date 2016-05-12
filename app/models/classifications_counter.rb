class ClassificationsCounter
  attr_reader :counts_by_user_group, :counts_by_user

  def initialize
    @counts_by_user_group = {}
    @counts_by_user = {}
  end

  def process(line)
    user_id = line["user_id"]
    counts_by_user[user_id] ||= 0
    counts_by_user[user_id] += 1

    if line["metadata"].include?("user_group_ids")
      metadata = JSON.load(line["metadata"] || "{}")
      user_group_ids = metadata["user_group_ids"] || []
      user_group_ids.each do |user_group_id|
        counts_by_user_group[user_group_id] ||= 0
        counts_by_user_group[user_group_id] += 1
      end
    end
  end

  def finalize
    StudentUser.joins(:user).where(users: {zooniverse_id: counts_by_user.keys}).find_each do |student_user|
      student_user.classifications_count = counts_by_user[student_user.zooniverse_id]
      student_user.save!
    end

    Classroom.where(zooniverse_group_id: counts_by_user_group.keys).find_each do |classroom|
      classroom.classifications_count = counts_by_user_group[classroom.zooniverse_group_id]
      classroom.save!
    end
  end
end
