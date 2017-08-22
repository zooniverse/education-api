module Projects
  class Create < Operation
    hash :attributes do
      integer :id
      string :slug
      integer :base_workflow_id, default: nil
    end

    def execute
      project = Project.create!(
        id: attributes[:id],
        slug: attributes[:slug],
        base_workflow_id: attributes[:base_workflow_id]
      )
    end
  end
end
