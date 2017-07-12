require 'spec_helper'

RSpec.describe Projects::Create do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }

  it 'creates a project' do
    described_class.run! current_user: current_user, client: client, attributes: {id: 1234, slug: 'zach/new-slug'}
    expect(Project.find(1234).slug).to eq('zach/new-slug')
  end

  it 'sets booleans' do
    described_class.run! current_user: current_user, client: client, attributes: {id: 1234, slug: 'zach/new-slug', clone_workflow: true, create_subject_set: true}
    project = Project.find(1234)
    expect(project.create_subject_set?).to be true
    expect(project.clone_workflow?).to be true
  end
end
