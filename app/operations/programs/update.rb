module Programs
  class Update < Operation
    integer :id

    hash :attributes do
      string :name
      boolean :custom, default: false
      string :description, default: ""
      hash :metadata, strip: false, default: {}
    end

    relationships do
      has_many :classrooms
    end

    def execute
      program = Program.find(id)

      program.name = attributes[:name] unless attributes[:name].blank?
      program.description = attributes[:description] unless attributes[:description].blank?
      program.custom = attributes[:custom] unless attributes[:custom].blank?
      program.metadata = attributes[:metadata] unless attributes[:metadata].blank?

      program.save!
    end
  end
end
