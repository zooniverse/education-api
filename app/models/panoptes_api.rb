class PanoptesApi
  def initialize(token)
    url = Rails.application.secrets["zooniverse_oauth_url"]

    @client = Faraday.new(url: url) do |faraday|
      faraday.request :panoptes_access_token, url: url, access_token: token
      faraday.request :panoptes_api_v1
      faraday.request :json
      faraday.response :json
#      faraday.response :raise_error
      faraday.adapter Faraday.default_adapter
    end
  end

  def me
    get("/me")["users"][0]
  end

  def get(path)
    client.get("/api" + path).body
  end

  def post(path, body = {})
    client.post("/api" + path, body).body
  end

  # Get a path and perform automatic depagination
  def paginate(path, resource: nil)
    resource = path.split("/").last if resource.nil?
    data = last_response = get(path)

    while next_path = last_response["meta"][resource]["next_href"]
      last_response = get(next_path)
      if block_given?
        yield data, last_response
      else
        data[resource].concat(last_response[resource]) if data[resource].is_a?(Array)
        data["meta"][resource].merge!(last_response["meta"][resource])
        data["links"].merge!(last_response["links"])
      end
    end

    data
  end

  private

  def client
    @client
  end
end
