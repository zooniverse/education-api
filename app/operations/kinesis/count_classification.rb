module Kinesis
  class CountClassification < Operation
    filters[:current_user].options[:default] = nil
    filters[:client].options[:default] = nil

    string :source
    string :type

    hash :data do
      hash :metadata do
        array :user_group_ids, default: [] do
          integer
        end
        string :selected_user_group_id, default: ""
      end

      hash :links do
        integer :project
        integer :workflow
        integer :user, default: nil
      end
    end

    def execute
      User.transaction do
        student_user_ids = StudentUser.joins(:user).where(users: {zooniverse_id: user_id}).pluck(:id)

        student_user_ids.each do |student_user_id|
          StudentUser.increment_counter :classifications_count, student_user_id
        end

        StudentAssignment
          .joins(:assignment)
          .where(assignments: {workflow_id: workflow_id}, student_user_id: student_user_ids).each do |student_assignment|
        if selected_user_group_id.blank? ||
            student_assignment.assignment.classroom.zooniverse_group_id == selected_user_group_id.to_i
          StudentAssignment.increment_counter :classifications_count, student_assignment.id
        end
      end

        if selected_user_group_id.blank?
          Classroom.where(zooniverse_group_id: user_group_ids).pluck(:id).each do |id|
            Classroom.increment_counter :classifications_count, id
          end
        else
          classroom = Classroom.find_by_zooniverse_group_id(selected_user_group_id)
          Classroom.increment_counter :classifications_count, classroom.id
        end
      end

      true
    end

    private

    def project_id
      data[:links][:project]
    end

    def workflow_id
      data[:links][:workflow]
    end

    def user_id
      data[:links][:user]
    end

    def user_group_ids
      data[:metadata][:user_group_ids]
    end

    def selected_user_group_id
      data[:metadata][:selected_user_group_id]
    end
  end
end
