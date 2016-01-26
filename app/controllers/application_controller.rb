class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  #
  before_action :require_login


  private

  def require_login
    authorization_header = request.headers["Authorization"]
    authorization_token  = authorization_header.match(/\ABearer (.*)\Z/)[1]

    @panoptes = PanoptesApi.new(authorization_token)
    panoptes_user = @panoptes.me

    @current_user = User.from_panoptes(panoptes_user)
  end

end
