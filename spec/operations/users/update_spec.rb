require 'spec_helper'

RSpec.describe Users::Update do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }

  it 'updates a user' do
    described_class.run! current_user: current_user, client: client,
      id: current_user.zooniverse_id, metadata: {"foo" => 1}
    expect(current_user.reload.metadata).to eq("foo" => 1)
  end
end
