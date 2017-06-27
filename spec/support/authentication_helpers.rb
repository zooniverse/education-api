module AuthenticationHelpers
  def authenticate!
    allow(controller).to receive(:client).and_return(client)
  end

  def client
    return @client if @client

    me_hash = {
      "id" => current_user.zooniverse_id,
      "login" => "login",
      "display_name" => "display_name"
    }

    @client = double(Panoptes::Client, me: me_hash).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end
  end

  def current_user
    @current_user ||= User.create(zooniverse_id: "9999", zooniverse_login: "login", zooniverse_display_name: "display_name")
  end
end
