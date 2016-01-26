class ClassroomsController < ApplicationController
  respond_to :json

  def index
    run Classrooms::Index
  end

  def show
    respond_with Classrooms::Show.run!(params)
  end

  def create
    run Classrooms::Create, params.fetch(:data).fetch(:attributes)
  end

  private

  def run(operation_class, data=params)
    operation = operation_class.run(data.merge(context: context))

    if operation.valid?
      respond_with operation.result
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end
end
