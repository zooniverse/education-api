require 'spec_helper'

RSpec.describe Classrooms::TeacherDestroy do
  let(:current_user) { build :user }
  let(:panoptes) { instance_double(Panoptes::Client, delete_user_group: true) }
  let(:classroom) { create :classroom, teachers: [current_user] }

  it 'marks the classroom as deleted' do
    described_class.run! current_user: current_user, panoptes: panoptes, id: classroom.id
    expect(classroom.reload).to be_deleted
  end

  it 'deletes the user group on panoptes' do
    described_class.run! current_user: current_user, panoptes: panoptes, id: classroom.id
    expect(panoptes).to have_received(:delete_user_group).with(classroom.zooniverse_group_id).once
  end
end
