class AssignmentsController < ApplicationController
  def index
    run Assignments::Index
  end

  def create
    run Assignments::Create, params.fetch(:data).fetch(:attributes)
  end

  def update
    run Assignments::Update, params.fetch(:data).fetch(:attributes).merge(id: params[:id])
  end

  def destroy
    run Assignments::Destroy, params
  end
end
