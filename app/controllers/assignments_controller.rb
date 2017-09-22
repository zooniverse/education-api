class AssignmentsController < ApplicationController
  def index
    run Assignments::Index, params,
      includes: [:student_assignments]
  end

  def create
    run Assignments::Create,
      params.fetch(:data),
      includes: [:student_assignments]
  end

  def update
    run Assignments::Update,
      params.fetch(:data),
      includes: [:student_assignments]
  end

  def destroy
    run Assignments::Destroy, params
  end
end
