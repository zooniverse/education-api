require 'spec_helper'

RSpec.describe Classifications::RequestNewExport do
  let(:panoptes)  { instance_double(Panoptes::Client, create_classifications_export: true) }
  let(:project_id) { 42 }

  it 'tells panoptes to build a new export' do
    described_class.run! panoptes: panoptes, project_id: project_id
    expect(panoptes).to have_received(:create_classifications_export).with(project_id).once
  end
end
