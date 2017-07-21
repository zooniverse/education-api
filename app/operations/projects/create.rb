module Projects
  class Create < Operation
    hash :attributes do
      integer :id
      string :slug
      boolean :custom_subject_set, default: false
    end

    def execute
      project = Project.create!(
        id: attributes[:id],
        slug: attributes[:slug],
        custom_subject_set: attributes[:custom_subject_set]
      )
    end
  end
end

