module WorkerHelpers
  def panoptes
    @panoptes ||= Panoptes::Client.new \
      url: Rails.application.secrets["zooniverse_oauth_url"],
      auth: {client_id: Rails.application.secrets["zooniverse_oauth_key"],
             client_secret: Rails.application.secrets["zooniverse_oauth_secret"]}
  end

  def project_id
    @project_id ||= Rails.application.secrets["zooniverse_project_id"]
  end
end
