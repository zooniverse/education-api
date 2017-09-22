require 'spec_helper'

RSpec.describe Programs::Create do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }

  it 'creates a program' do
    result = described_class.run! current_user: current_user, client: client, attributes: {slug: 'newprogram', name: 'New Program!'}
    expect(Program.last.slug).to eq('newprogram')
  end
end
