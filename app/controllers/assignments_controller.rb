class AssignmentsController < ApplicationController
  def index
    run Assignments::Index, params,
      includes: [:student_assignments]
  end

  def create
    run Assignments::Create.with(client: panoptes_application_client),
      params.fetch(:data),
      includes: [:student_assignments]
  end

  def update
    run Assignments::Update.with(client: panoptes_application_client),
      params.fetch(:data).merge(id: params[:id]),
      includes: [:student_assignments]
  end

  def destroy
    run Assignments::Destroy.with(client: panoptes_application_client),
      params
  end
end
