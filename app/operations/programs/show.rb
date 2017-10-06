module Programs
  class Show < Operation
    integer :id

    def execute
      Program.find(id)
    end
  end
end
