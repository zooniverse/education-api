module Assignments
  class Create < Operation
    hash :attributes do
      integer :workflow_id
      string :name
      hash :metadata, strip: false, default: {}
    end

    relationships do
      belongs_to :classroom
      has_many :student_users
      has_many :subjects
    end

    def execute
      if program.custom?
        subject_set = create_and_fill_subject_set(workflow['links']['project'])
        client.add_subject_set_to_workflow(workflow["id"], subject_set["id"])
      end

      student_users = classroom.student_users.where(id: student_user_ids)
      assignment = classroom.assignments.create!(
        name: attributes[:name],
        metadata: attributes[:metadata],
        workflow_id: workflow['id'],
        student_users: student_users
      )

      assignment.update!(subject_set_id: subject_set["id"]) if subject_set
      assignment
    end

    def clone_workflow(workflow_id)
      base_workflow = client.workflow(workflow_id)

      attributes = base_workflow.slice('primary_language', 'tasks', 'first_task', 'configuration')
      attributes['display_name'] = uuid
      attributes['serialize_with_project'] = false
      attributes['retirement'] = {criteria: 'never_retire', options: {}}
      attributes['links'] = {
        project: base_workflow['links']['project']
      }

      client.create_workflow(attributes)
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def workflow
      @workflow ||= if program.custom?
        clone_workflow(attributes[:workflow_id])
      else
        client.workflow(attributes[:workflow_id])
      end
    end

    def classroom
      @classroom ||= current_user.taught_classrooms.find(classroom_id)
    end

    def program
      @program ||= classroom.program
    end

    def create_and_fill_subject_set(project_id)
      subject_set = client.create_subject_set(
        display_name: uuid,
        links: {
          project: project_id
        }
      )

      FillSubjectSetWorker.perform_async(subject_set["id"], subject_ids&.uniq)
      subject_set
    end
  end
end
