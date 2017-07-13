module Projects
  class Update < Operation
    integer :id

    hash :attributes do
      boolean :clone_workflow, default: false
      boolean :create_subject_set, default: false
    end

    def execute
      project = Project.find(id)
      project.update!(clone_workflow: attributes[:clone_workflow], create_subject_set: attributes[:create_subject_set])
    end
  end
end

