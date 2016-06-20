class AssignmentsController < ApplicationController
  def index
    run Assignments::Index
  end

  def create
    run Assignments::Create, params.fetch(:data).merge(path_params)
  end

  def update
    run Assignments::Update, params.fetch(:data).merge(path_params)
  end

  def destroy
    run Assignments::Destroy, params
  end

  private

  def path_params
    params.slice(:classroom_id, :id)
  end
end
