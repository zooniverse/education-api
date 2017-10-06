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
        slug: attributes[:slug],
        name: attributes[:name],
      )
      program.custom = attributes[:custom] if attributes[:custom]
      program.description = attributes[:description] if attributes[:description]
      program.metadata = attributes[:metadata] if attributes[:metadata]
      program.tap(&:save!)
    end
  end
end
