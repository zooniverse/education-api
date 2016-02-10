class ApplicationController < ActionController::Base
  before_action :require_login

  attr_reader :panoptes
  attr_reader :current_user

  private

  def require_login
    panoptes_user = panoptes.me
    @current_user = User.from_panoptes(panoptes_user)
  end

  def panoptes
    return @panoptes if @panoptes

    authorization_header = request.headers["Authorization"]
    authorization_token  = authorization_header.match(/\ABearer (.*)\Z/)[1]

    @panoptes = Panoptes::Client.new \
      url: Rails.application.secrets["zooniverse_oauth_url"],
      auth: {token: authorization_token}
  end

  def run(operation_class, data=params)
    operation = operation_class.run(data.merge(panoptes: panoptes, current_user: current_user))

    if operation.valid?
      respond_with operation.result
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end
end
