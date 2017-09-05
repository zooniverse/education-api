module Programs
  class Create < Operation
    hash :attributes do
      string :slug
      string :name
      boolean :custom, default: false
      string :description, default: ""
      hash :metadata, strip: false, default: {}
    end

    relationships do
      has_many :classrooms
    end

    def execute
      program = Program.create!(
        id: attributes[:id],
        slug: attributes[:slug],
        name: attributes[:name],
        custom: attributes[:custom]
      )
    end
  end
end
