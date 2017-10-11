class ProgramsController < ApplicationController
  skip_before_action :require_login

  def show
    anon_run Programs::Show, params
  end

  def index
    anon_run Programs::Index
  end

  def create
    run Programs::Create, params.fetch(:data)
  end

  private

  def anon_run(operation_class, data=params)
    operation = operation_class.run(data)

    if operation.valid?
      respond_with operation.result
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end
end
