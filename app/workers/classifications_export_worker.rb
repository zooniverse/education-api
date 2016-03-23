class ClassificationsExportWorker
  def perform
    path = Classifications::DownloadExport.run! project_id: 593
    Classifications::ProcessExport.run! export_path: path
  end
end
