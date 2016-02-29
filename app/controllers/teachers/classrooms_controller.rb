module Teachers
  class ClassroomsController < TeacherAreaController
    respond_to :json

    def index
      run Classrooms::TeacherIndex
    end

    def create
      run Classrooms::TeacherCreate, params.fetch(:data).fetch(:attributes)
    end
  end
end
