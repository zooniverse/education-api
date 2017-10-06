module AuthenticationHelpers
  def authenticate!
    allow(controller).to receive(:client).and_return(user_client)
  end

  def application_client
    return @application_client if @application_client

    me_hash = {
      "id" => current_user.zooniverse_id,
      "login" => "login",
      "display_name" => "display_name"
    }

    @application_client = double(Panoptes::Client, me: me_hash).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end

    @application_client
  end

  def user_client
    return @user_client if @user_client

    me_hash = {
      "id" => current_user.zooniverse_id,
      "login" => "login",
      "display_name" => "display_name"
    }


    @user_client = double(Panoptes::Client, me: me_hash).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end


    @user_client
  end

  def current_user
    @current_user ||= User.create(zooniverse_id: "9999", zooniverse_login: "login", zooniverse_display_name: "display_name")
  end
end
