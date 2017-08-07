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

  # Rails 5 gives you a Params object instead of a hash. ActiveInteraction hates it.
  def params_hash
    params.to_h
  end

  def path_params
    params_hash.slice(:classroom_id, :id, :relationships)
  end

  def panoptes_application_client
    @panoptes_application_client ||= Panoptes::Client.new \
      env: Rails.env.to_sym,
      auth: {client_id: Rails.application.secrets["zooniverse_oauth_key"],
             client_secret: Rails.application.secrets["zooniverse_oauth_secret"]}
  end
end
