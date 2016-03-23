require 'spec_helper'

RSpec.describe Users::Update do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:panoptes) { instance_double(Panoptes::Client, join_user_group: true) }

  it 'updates a user' do
    described_class.run! current_user: current_user, panoptes: panoptes,
      id: current_user.zooniverse_id, metadata: {"foo" => 1}
    expect(current_user.reload.metadata).to eq("foo" => 1)
  end
end
