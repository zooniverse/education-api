module Programs
  class Index < ActiveInteraction::Base
    def execute
      Program.all
    end
  end
end
