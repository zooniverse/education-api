module Assignments
  class Create < Operation
    integer :base_workflow_id, default: Rails.application.secrets["zooniverse_project_id"]
    integer :classroom_id
    string :name
    hash :metadata, strip: false, default: {}

    def execute
      classroom = current_user.taught_classrooms.find(classroom_id)

      subject_set = panoptes.create_subject_set display_name: uuid
      workflow = clone_workflow(base_workflow_id, subject_set)

      classroom.assignments.create! name: name, workflow_id: workflow["id"], subject_set_id: subject_set["id"]
    end

    def clone_workflow(workflow_id, subject_set)
      base_workflow = panoptes.workflow(base_workflow_id)

      attributes = base_workflow.slice('primary_language', 'tasks', 'first_task', 'configuration')
      attributes['display_name'] = uuid
      attributes['retirement'] = {criteria: 'never', options: {}}
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
