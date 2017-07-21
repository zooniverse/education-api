class AssignmentsController < ApplicationController
  def index
    run Assignments::Index, params,
      includes: [:student_assignments]
  end

  def create
    run Assignments::Create.with(client: panoptes_application_client),
      params_hash.fetch(:data).merge(path_params),
      includes: [:student_assignments]
  end

  def update
    run Assignments::Update.with(client: panoptes_application_client),
      params_hash.fetch(:data).merge(path_params),
      includes: [:student_assignments]
  end

  def destroy
    run Assignments::Destroy.with(client: panoptes_application_client),
      params_hash
  end

  private

  def path_params
    params_hash.slice(:classroom_id, :id, :relationships)
  end
end
