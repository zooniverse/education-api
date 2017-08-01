require 'spec_helper'

RSpec.describe Projects::Create do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }

  it 'creates a project' do
    described_class.run! current_user: current_user, client: client, attributes: {id: 1234, slug: 'zach/new-slug'}
    expect(Project.find(1234).slug).to eq('zach/new-slug')
  end

  it 'sets base workflow id' do
    described_class.run! current_user: current_user, client: client, attributes: {id: 1234, slug: 'zach/new-slug', base_workflow_id: 9999}
    project = Project.find(1234)
    expect(project.base_workflow_id?).to be 9999
  end
end
