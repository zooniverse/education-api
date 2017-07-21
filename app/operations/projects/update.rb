module Projects
  class Update < Operation
    integer :id

    hash :attributes do
      boolean :custom_subject_set, default: false
    end

    def execute
      project = Project.find(id)
      project.update!(custom_subject_set: attributes[:custom_subject_set])
    end
  end
end

