module Assignments
  class Create < Operation
    integer :base_project_id, default: Rails.application.secrets["zooniverse_project_id"]
    integer :base_workflow_id, default: Rails.application.secrets["zooniverse_workflow_id"]

    hash :attributes do
      string :name
      hash :metadata, strip: false, default: {}
    end

    relationships do
      belongs_to :classroom
      has_many :student_users
      has_many :subjects
    end

    def execute
      classroom = current_user.taught_classrooms.find(classroom_id)

      subject_set = panoptes.create_subject_set display_name: uuid, links: {
        project: base_project_id,
        subjects: []
      }

      FillSubjectSetWorker.perform_async(subject_set["id"], subject_ids)

      workflow = clone_workflow(base_workflow_id, subject_set)

      student_users = classroom.student_users.where(id: student_user_ids)
      classroom.assignments.create! name: attributes[:name], metadata: attributes[:metadata], workflow_id: workflow["id"], subject_set_id: subject_set["id"], student_users: student_users
    end

    def clone_workflow(workflow_id, subject_set)
      base_workflow = panoptes.workflow(base_workflow_id)

      attributes = base_workflow.slice('primary_language', 'tasks', 'first_task', 'configuration')
      attributes['display_name'] = uuid
      attributes['retirement'] = {criteria: 'never_retire', options: {}}
      attributes['links'] = {
        project: base_workflow['links']['project'],
        subject_sets: [subject_set['id']]
      }

      panoptes.create_workflow(attributes)
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end
  end
end
