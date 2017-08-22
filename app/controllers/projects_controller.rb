class ProjectsController < ApplicationController
  before_action :set_project_id, only: :create

  def create
    run Projects::Create, params.fetch(:data)
  end

  def update
    run Projects::Update, params.fetch(:data).merge(id: params[:id])
  end

  private

  def set_project_id
    slug = params.fetch(:data).fetch(:attributes).fetch(:slug)
    return unless slug
    project ||= panoptes_application_client.projects(search: slug).first
    params[:data][:attributes][:id] = project[:id]
  end
end
