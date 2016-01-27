class ClassroomsController < ApplicationController
  respond_to :json

  def index
    run Classrooms::Index
  end

  def show
    run Classrooms::Show
  end

  def create
    run Classrooms::Create, params.fetch(:data).fetch(:attributes)
  end
end
