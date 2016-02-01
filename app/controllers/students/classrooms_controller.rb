module Students
  class ClassroomsController < ApplicationController
    respond_to :json

    def index
      run Classrooms::StudentIndex
    end

    def show
      run Classrooms::StudentShow
    end
  end
end
