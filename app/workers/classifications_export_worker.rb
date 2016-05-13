class ClassificationsExportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  include WorkerHelpers

  recurrence { daily.hour_of_day(7) }

  def perform
    path = Classifications::DownloadExport.run! project_id: project_id, panoptes: panoptes
    Classifications::ProcessExport.run! export_path: path.to_s
  end
end
