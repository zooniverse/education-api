require 'spec_helper'

RSpec.describe Classrooms::TeacherDestroy do
  let(:current_user) { build :user }
  let(:client) { instance_double(Panoptes::Client) }
  let(:classroom) { create :classroom, teachers: [current_user] }

  before { allow(client).to receive(:delete_user_group).and_return(true) }


  it 'marks the classroom as deleted' do
    described_class.run! current_user: current_user, client: client, id: classroom.id
    expect(classroom.reload).to be_deleted
  end

  it 'deletes the user group on panoptes' do
    described_class.run! current_user: current_user, client: client, id: classroom.id
    expect(client).to have_received(:delete_user_group).with(classroom.zooniverse_group_id).once
  end
end
