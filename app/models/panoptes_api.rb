class PanoptesApi
  def initialize(token)
    url = Rails.application.secrets["zooniverse_oauth_url"]

    @client = Faraday.new(url: url) do |faraday|
      faraday.request :panoptes_access_token, url: url, access_token: token
      faraday.request :panoptes_api_v1
      faraday.request :json
      faraday.response :json
      faraday.response :raise_error
      faraday.adapter Faraday.default_adapter
    end
  end

  def me
    get("/api/me").body["users"][0]
  end

  def get(path)
    client.get(path)
  end

  private

  def client
    @client
  end
end
