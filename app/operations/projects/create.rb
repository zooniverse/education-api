module Projects
  class Create < Operation
    hash :attributes do
      string :slug
      boolean :clone_workflow, default: false
      boolean :create_subject_set, default: false
    end

    def execute
      project = Project.create!(slug: attributes[:slug], clone_workflow: attributes[:clone_workflow], create_subject_set: attributes[:create_subject_set])
    end
  end
end

