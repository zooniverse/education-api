module Teachers
  class ClassroomsController < TeacherAreaController
    def index
      run Classrooms::TeacherIndex
    end

    def create
      run Classrooms::TeacherCreate, params.fetch(:data).fetch(:attributes)
    end

    def update
      run Classrooms::TeacherUpdate, params.fetch(:data).fetch(:attributes).merge(id: params[:id])
    end

    def destroy
      run Classrooms::TeacherDestroy, params
    end
  end
end
