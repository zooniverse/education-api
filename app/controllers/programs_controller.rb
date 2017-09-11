class ProgramsController < ApplicationController
  def create
    run Programs::Create, params.fetch(:data)
  end

  def update
    run Programs::Update, params.fetch(:data).merge(id: params[:id])
  end
end
