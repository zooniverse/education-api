module Programs
  class Index < Operation
    def execute
      Program.all
    end
  end
end
