module Assignments
  class Create < Operation
    extend ::NewRelic::Agent::MethodTracer

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
      subject_set = create_subject_set
      workflow = clone_workflow(base_workflow_id, subject_set)
      student_users = find_student_users(classroom)

      fill_subject_set(subject_set)
      create_assignment(classroom, workflow, subject_set, student_users)
    end

    def create_subject_set
      panoptes.create_subject_set display_name: uuid, links: {project: base_project_id }
    end

    def fill_subject_set(subject_set)
      FillSubjectSetWorker.perform_async(subject_set["id"], subject_ids)
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

    def find_student_users(classroom)
      classroom.student_users.where(id: student_user_ids)
    end

    def create_assignment(classroom, workflow, subject_set, student_users)
      classroom.assignments.create! \
        name: attributes[:name],
        metadata: attributes[:metadata],
        workflow_id: workflow["id"],
        subject_set_id: subject_set["id"],
        student_users: student_users
    end

    add_method_tracer :create_subject_set, 'Custom/assignment_create/create_subject_set'
    add_method_tracer :fill_subject_set,   'Custom/assignment_create/enqueue_fill_subject_set_worker'
    add_method_tracer :clone_workflow,     'Custom/assignment_create/clone_workflow'
    add_method_tracer :find_student_users, 'Custom/assignment_create/find_student_users'
    add_method_tracer :create_assignment,  'Custom/assignment_create/create_assignment'

    def uuid
      @uuid ||= SecureRandom.uuid
    end
  end
end
