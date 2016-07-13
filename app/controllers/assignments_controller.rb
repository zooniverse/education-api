class AssignmentsController < ApplicationController
  def index
    run Assignments::Index
  end

  def create
    run Assignments::Create.with(panoptes: panoptes_application_client),
      params.fetch(:data).merge(path_params)
  end

  def update
    run Assignments::Update.with(panoptes: panoptes_application_client),
      params.fetch(:data).merge(path_params)
  end

  def destroy
    run Assignments::Destroy.with(panoptes: panoptes_application_client),
      params
  end

  private

  def path_params
    params.slice(:classroom_id, :id)
  end

  def panoptes_application_client
    @panoptes_application_client ||= Panoptes::Client.new \
      url: Rails.application.secrets["zooniverse_oauth_url"],
      auth: {client_id: Rails.application.secrets["zooniverse_oauth_key"],
             client_secret: Rails.application.secrets["zooniverse_oauth_secret"]}
  end
end
