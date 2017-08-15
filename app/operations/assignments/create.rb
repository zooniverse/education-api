module Assignments
  class Create < Operation
    integer :project_id
    integer :workflow_id, default: nil

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

      subject_set = project.base_workflow_id? ? create_and_fill_subject_set : nil
      workflow_id = get_workflow(subject_set)

      student_users = classroom.student_users.where(id: student_user_ids)
      assignment = classroom.assignments.create!(
        name: attributes[:name],
        metadata: attributes[:metadata],
        workflow_id: workflow_id,
        student_users: student_users
      )

      assignment.update!(subject_set_id: subject_set["id"]) if subject_set
      assignment
    end

    def clone_workflow(workflow_id, subject_set)
      base_workflow = client.workflow(project.base_workflow_id)

      attributes = base_workflow.slice('primary_language', 'tasks', 'first_task', 'configuration')
      attributes['display_name'] = uuid
      attributes['retirement'] = {criteria: 'never_retire', options: {}}
      attributes['links'] = {
        project: base_workflow['links']['project'],
        subject_sets: [subject_set['id']]
      }

      client.create_workflow(attributes)
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def get_workflow(subject_set)
      if project.base_workflow_id?
        workflow = clone_workflow(project.base_workflow_id, subject_set)
        workflow["id"]
      elsif workflow_id?
        workflow_id
      else
        raise ActiveInteraction::InvalidInteractionError.new("Workflow id missing and project does not clone")
      end
    end

    def project
      project ||= Project.find(project_id)
    end

    def create_and_fill_subject_set
      subject_set = client.create_subject_set display_name: uuid, links: {
        project: project_id
      }

      FillSubjectSetWorker.perform_async(subject_set["id"], subject_ids&.uniq)
      subject_set
    end
  end
end
