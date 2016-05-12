class ClassificationsExportWorker
  def perform
    panoptes = Panoptes::Client.new \
      url: Rails.application.secrets["zooniverse_oauth_url"],
      auth: {client_id: Rails.application.secrets["zooniverse_oauth_key"],
             client_secret: Rails.application.secrets["zooniverse_oauth_secret"]}
    project_id = Rails.application.secrets["zooniverse_project_id"]

    path = Classifications::DownloadExport.run! project_id: project_id, panoptes: panoptes
    Classifications::ProcessExport.run! export_path: path.to_s
  end
end
