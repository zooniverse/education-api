class Cartodb
  CARTODB_ACCOUNT = ENV["CARTODB_ACCOUNT"]
  CARTODB_APIKEY = ENV["CARTODB_APIKEY"]

  attr_accessor :account, :api_key

  def initialize(account = CARTODB_ACCOUNT, api_key = CARTODB_APIKEY)
    @account = account
    @api_key = api_key
  end

  def get(sql_query)
    uri = URI(get_url.gsub(/__SQLQUERY__/, URI.escape(sql_query)))
    res = Net::HTTP.get(uri)

    JSON.parse(res).tap do |res|
      raise StandardError, res["error"] if res["error"]
    end
  end

  def post(sql_query)
    uri = URI(post_url)
    res = Net::HTTP.post_form(uri, "q" => sql_query, "api_key" => api_key)

    JSON.parse(res.body).tap do |res|
      raise StandardError, res["error"] if res["error"]
    end
  end

  def get_url
    @get_url ||= "https://#{account}.cartodb.com/api/v2/sql?q=__SQLQUERY__&api_key=#{api_key}"
  end

  def post_url
    @post_url ||= "https://#{account}.cartodb.com/api/v2/sql"
  end
end
