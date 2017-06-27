class FillSubjectSetWorker
  BATCH_SIZE = 200

  include Sidekiq::Worker
  include WorkerHelpers

  def perform(subject_set_id, subject_ids)
    batch, rest = select_batch(subject_ids)
    client.add_subjects_to_subject_set(subject_set_id, batch)

    if rest.present?
      FillSubjectSetWorker.perform_async(subject_set_id, rest)
    end
  end

  def select_batch(subject_ids)
    batch = subject_ids[0..(BATCH_SIZE - 1)]
    rest  = subject_ids[BATCH_SIZE..-1]
    [batch, rest]
  end
end
