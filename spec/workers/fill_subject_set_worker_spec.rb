require 'spec_helper'

RSpec.describe FillSubjectSetWorker do
  let(:client) { instance_double(Panoptes::Client, add_subjects_to_subject_set: true) }
  let(:batch_size) { 5 }
  let(:subject_set_id) { double }
  subject(:worker) { described_class.new }

  before do
    stub_const("FillSubjectSetWorker::BATCH_SIZE", batch_size)
    allow(worker).to receive(:client).and_return(client)
  end

  it 'should add a batch to panoptes' do
    expect(client).to receive(:add_subjects_to_subject_set).with(subject_set_id, (1..batch_size).to_a)
    worker.perform(subject_set_id, (1..100).to_a)
  end

  it 'should reenqueue with the rest of the ids' do
    expect(described_class).to receive(:perform_async).with(subject_set_id, ((batch_size+1)..100).to_a)
    worker.perform(subject_set_id, (1..100).to_a)
  end

  it 'should not reenqueue if there are no more ids' do
    expect(described_class).not_to receive(:perform_async)
    worker.perform(subject_set_id, (1..batch_size).to_a)
  end
end
