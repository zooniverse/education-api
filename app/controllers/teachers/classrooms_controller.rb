module Teachers
  class ClassroomsController < TeacherAreaController
    def index
      run Classrooms::TeacherIndex
    end

    def create
      run Classrooms::TeacherCreate, params.to_h.fetch(:data).fetch(:attributes)
    end

    def update
      run Classrooms::TeacherUpdate, params.to_h.fetch(:data).fetch(:attributes).merge(id: params[:id])
    end

    def destroy
      run Classrooms::TeacherDestroy, params.to_h
    end
  end
end
