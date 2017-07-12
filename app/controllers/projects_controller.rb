class ProjectsController < ApplicationController
  before_action :set_project_id, only: :create

  def create
    run Projects::Create, params_hash.fetch(:data)#.fetch(:attributes)
  end

  def update
    run Projects::Update, params_hash.fetch(:data).fetch(:attributes).merge(id: params[:id], client: client, current_user: current_user)
  end

  private

  def set_project_id
    slug = params_hash.fetch(:data).fetch(:attributes).fetch(:slug)
    return unless slug
    project = panoptes_application_client.project slug
    params[:data][:attributes][:id] = project[:id]
  end
end
