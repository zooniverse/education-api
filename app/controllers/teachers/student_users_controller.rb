module Teachers
  class StudentUsersController < TeacherAreaController
    def destroy
      run StudentUsers::Destroy, params
    end
  end
end
