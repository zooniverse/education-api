class TeacherAreaController < ApplicationController
  def run(operation_class, data=params)
    operation = operation_class.run(data.merge(client: client, current_user: current_user))

    if operation.valid?
      respond_with :teachers, operation.result, include: [:students]
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end
end
