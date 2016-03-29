class StudentAreaController < ApplicationController
  def run(operation_class, data=params)
    operation = operation_class.run(data.merge(panoptes: panoptes, current_user: current_user))

    if operation.valid?
      respond_with :students, operation.result, include: [:students]
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end

end
