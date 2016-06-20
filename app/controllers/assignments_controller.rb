class AssignmentsController < ApplicationController
  def index
    run Assignments::Index
  end

  def create
    run Assignments::Create, params.fetch(:data).fetch(:attributes)
  end

  def destroy
    run Assignments::Destroy, params
  end
end
