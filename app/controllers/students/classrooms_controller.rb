module Students
  class ClassroomsController < StudentAreaController
    def index
      run Classrooms::StudentIndex
    end

    def show
      run Classrooms::StudentShow
    end

    def join
      run Classrooms::Join
    end
  end
end
