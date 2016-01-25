class ClassroomsController < ApplicationController
  respond_to :json

  def show
    respond_with Classrooms::Show.run!(params)
  end

  def create
    outcome = Classrooms::Create.run(params.fetch(:data).fetch(:attributes))

    if outcome.valid?
      respond_with outcome.result
    else
      render json: ErrorSerializer.serialize(outcome), status: :unprocessable_entity
    end
  end
end
