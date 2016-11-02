require 'csv'

namespace :report do
  task :all => [:teachers, :classrooms, :students, :assignments]

  desc "Overview of teachers"
  task :teachers => [:environment] do
    CSV.open(Rails.root.join('teachers.csv'), 'wb') do |csv|
      csv << %w(user_id classroom_id registered_as_teacher_at login age course country foundon setting feedback resource)
      TeacherUser.includes(:user).find_each do |teacher_user|
        user = teacher_user.user
        metadata = user.metadata || {}

        csv << [
          user.zooniverse_id,
          teacher_user.classroom_id,
          user.created_at,
          user.zooniverse_login,
          metadata["age"],
          metadata["course"],
          metadata["country"],
          metadata["foundon"],
          metadata["setting"],
          metadata["feedback"],
          metadata["resource"]
        ]
      end
    end

    puts 'teachers.csv done'
  end

  task :classrooms => [:environment] do
    CSV.open(Rails.root.join('classrooms.csv'), 'wb') do |csv|
      csv << %w(classroom_id user_group_id created_at name subject school description)
      Classroom.active.find_each do |classroom|
        csv << [
          classroom.id,
          classroom.zooniverse_group_id,
          classroom.created_at,
          classroom.name,
          classroom.subject,
          classroom.school,
          classroom.description
        ]
      end
    end

    puts 'classrooms.csv done'
  end

  task :assignments => [:environment] do
    CSV.open(Rails.root.join('assignments.csv'), 'wb') do |csv|
      csv << %w(assignment_id classroom_id workflow_id created_at name description duedate
        filters_species filters_timesOfDay filters_distanceToWaterMin filters_distanceToWaterMax filters_habitats filters_seasons filters_distanceToHumansMin filters_distanceToHumansMax filters_dateStart filters_dateEnd
        subject_count classifications_target)
      Assignment.find_each do |assignment|
        metadata = assignment.metadata || {}
        filters = metadata["filters"] || {}

        csv << [
          assignment.id,
          assignment.classroom_id,
          assignment.workflow_id,
          assignment.created_at,
          assignment.name,
          metadata["description"],
          metadata["duedate"],
          filters["species"]&.join("+"),
          filters["timesOfDay"]&.join("+"),
          filters["distanceToWaterMin"],
          filters["distanceToWaterMax"],
          filters["habitats"]&.join("+"),
          filters["seasons"]&.join("+"),
          filters["distanceToHumansMin"],
          filters["distanceToHumansMax"],
          filters["dateStart"],
          filters["dateEnd"],
          metadata["subjects"]&.size,
          metadata["classifications_target"]
        ]
      end
    end

    puts 'assignments.csv done'
  end

  task :students => [:environment] do
    CSV.open(Rails.root.join('students.csv'), 'wb') do |csv|
      csv << %w(classroom_id user_id login)
      Classroom.includes(:students).find_each do |classroom|
        classroom.students.each do |student|
          csv << [
            classroom.id,
            student.zooniverse_id,
            student.zooniverse_login
          ]
        end
      end
    end

    puts 'students.csv done'
  end
end
