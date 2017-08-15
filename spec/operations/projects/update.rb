require 'spec_helper'

RSpec.describe Projects::Update do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }
  let(:project) { create(:project) }

  it 'updates a project' do
    described_class.run! current_user: current_user, client: client, id: project.id, attributes: {clone_workflow: true, create_subject_set: true}
    project.reload
    expect(project.create_subject_set?).to be true
    expect(project.clone_workflow?).to be true
  end
end
