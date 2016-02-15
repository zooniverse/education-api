module Students
  class ClassroomsController < StudentAreaController
    respond_to :json

    def index
      run Classrooms::StudentIndex
    end

    def show
      run Classrooms::StudentShow
    end
  end
end
