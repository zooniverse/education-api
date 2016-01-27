class ClassroomsController < ApplicationController
  respond_to :json

  def index
    run Classrooms::Index
  end

  def show
    respond_with Classrooms::Show.run!(params)
  end

  def create
    run Classrooms::Create, params.fetch(:data).fetch(:attributes)
  end
end
