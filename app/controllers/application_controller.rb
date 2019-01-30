class ApplicationController < ActionController::Base
  class Unauthorized < StandardError; end

  respond_to :json
  rescue_from Unauthorized, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Panoptes::Client::ResourceNotFound, with: :not_found

  before_action :require_login, except: [:root]

  attr_reader :panoptes
  attr_reader :current_user

  def root
    render json: {
      revision: Rails.application.revision
    }
  end

  private

  def require_login
    panoptes_user = client.me
    @current_user = User.from_panoptes(panoptes_user)
  rescue Panoptes::Client::ServerError
    raise Unauthorized, "could not check authentication with Panoptes"
  end

  def client
    return @client if @client

    authorization_header = request.headers["Authorization"]
    raise Unauthorized, "missing authorization header" unless authorization_header

    authorization_token  = authorization_header.match(/\ABearer (.*)\Z/).try { |match| match[1] }
    raise Unauthorized, "missing bearer token" unless authorization_token

    @client = Panoptes::Client.new \
      env: Rails.env.to_sym,
      auth: {token: authorization_token}
  end

  def run(operation_class, data=params, includes: [])
    operation = operation_class.run(data.merge(client: client, current_user: current_user))

    if operation.valid?
      respond_with operation.result, include: includes
    else
      render json: ErrorSerializer.serialize(operation), status: :unprocessable_entity
    end
  end

  def render_exception(status, exception)
    self.response_body = nil
    render status: status, json: { error: exception.message }
  end

  def not_authorized(exception)
    render_exception :forbidden, exception
  end

  def not_found(exception)
    render_exception :not_found, exception
  end

  def panoptes_application_client
    @panoptes_application_client ||= Panoptes::Client.new \
      env: Rails.env.to_sym,
      auth: {client_id: Rails.application.secrets["zooniverse_oauth_key"],
             client_secret: Rails.application.secrets["zooniverse_oauth_secret"]},
      params: {:admin => true}
  end
end
