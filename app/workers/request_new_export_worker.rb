class RequestNewExportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  include WorkerHelpers

  recurrence { daily.hour_of_day(22) }

  def perform
    Classifications::RequestNewExport.run! panoptes: panoptes, project_id: project_id
  end
end
