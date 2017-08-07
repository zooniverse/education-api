module WorkerHelpers
  def client
    @client ||= Panoptes::Client.new \
      env: Rails.env.to_sym,
      auth: {client_id: Rails.application.secrets["zooniverse_oauth_key"],
             client_secret: Rails.application.secrets["zooniverse_oauth_secret"]}
  end

  def project_id
    @project_id ||= Rails.application.secrets["zooniverse_project_id"]
  end
end
