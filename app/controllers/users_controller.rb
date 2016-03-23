class UsersController < ApplicationController
  def update
    raise Unauthorized unless params[:id] == current_user.zooniverse_id
    run Users::Update, params.fetch(:data).fetch(:attributes).merge(id: params[:id])
  end
end
