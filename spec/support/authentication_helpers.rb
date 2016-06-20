module AuthenticationHelpers
  def authenticate!
    allow(controller).to receive(:panoptes).and_return(panoptes_client)
  end

  def panoptes_client
    return @panoptes_client if @panoptes_client

    me_hash = {
      "id" => current_user.zooniverse_id,
      "login" => "login",
      "display_name" => "display_name"
    }

    @panoptes_client = double(Panoptes::Client, me: me_hash).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end
  end

  def current_user
    @current_user ||= User.create(zooniverse_id: "1")
  end
end
