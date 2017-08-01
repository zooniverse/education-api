module Projects
  class Update < Operation
    integer :id

    hash :attributes do
      integer :base_workflow_id, default: false
    end

    def execute
      project = Project.find(id)
      project.update!(base_workflow_id: attributes[:base_workflow_id])
    end
  end
end
