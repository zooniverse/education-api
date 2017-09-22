module Assignments
  class Create < Operation
    hash :attributes do
      integer :workflow_id, default: nil
      string :name
      hash :metadata, strip: false, default: {}
    end

    relationships do
      belongs_to :classroom
      has_many :student_users
      has_many :subjects
    end

    def execute
      subject_set = program.custom? ? create_and_fill_subject_set : nil
      local_workflow_id = get_workflow_id(subject_set)

      student_users = classroom.student_users.where(id: student_user_ids)
      assignment = classroom.assignments.create!(
        name: attributes[:name],
        metadata: attributes[:metadata],
        workflow_id: local_workflow_id,
        student_users: student_users
      )

      assignment.update!(subject_set_id: subject_set["id"]) if subject_set
      assignment
    end

    def clone_workflow(local_workflow_id, subject_set)
      base_workflow = client.workflow(local_workflow_id)

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

    def get_workflow_id(subject_set)
      if program.custom?
        workflow = clone_workflow(attributes[:workflow_id], subject_set)
        workflow["id"]
      else
        attributes[:workflow_id]
      end
    end

    def classroom
      @classroom ||= current_user.taught_classrooms.find(classroom_id)
    end

    def program
      @program ||= classroom.program
    end

    def create_and_fill_subject_set
      subject_set = client.create_subject_set display_name: uuid, links: {
        program: program.id
      }

      FillSubjectSetWorker.perform_async(subject_set["id"], subject_ids&.uniq)
      subject_set
    end
  end
end
