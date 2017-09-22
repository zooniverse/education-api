class ProgramsController < ApplicationController
  def show
    run Programs::Show, params
  end

  def index
    run Programs::Index
  end

  def create
    run Programs::Create, params.fetch(:data)
  end

  def update
    run Programs::Update, params.fetch(:data).merge(id: params[:id])
  end
end
