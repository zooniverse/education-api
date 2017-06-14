class ApplicationController < ActionController::Base
  class Unauthorized < StandardError; end

  respond_to :json
  rescue_from Unauthorized, with: :not_authorized

  before_action :require_login

  attr_reader :panoptes
  attr_reader :current_user

  private

  def require_login
    panoptes_user = panoptes.me
    @current_user = User.from_panoptes(panoptes_user)
  rescue Panoptes::Client::ServerError
    raise Unauthorized, "could not check authentication with Panoptes"
  end

  def panoptes
    return @client if @client

    authorization_header = request.headers["Authorization"]
    raise Unauthorized, "missing authorization header" unless authorization_header

    authorization_token  = authorization_header.match(/\ABearer (.*)\Z/).try { |match| match[1] }
    raise Unauthorized, "missing bearer token" unless authorization_token

    @client = Panoptes::Client.new \
      url: Rails.application.secrets["zooniverse_oauth_url"],
      auth: {token: authorization_token}
  end

  def run(operation_class, data=params.to_h, includes: [])
    operation = operation_class.run(data.merge(panoptes: panoptes, current_user: current_user))

    if operation.valid?
      respond_with operation.result, include: includes
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end

  def not_authorized(exception)
    render json: {"error" => "not authorized to acess this resource: #{exception.message}"}, status: :forbidden
  end
end
