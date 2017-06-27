require 'spec_helper'

RSpec.describe StudentUsers::Destroy do
  let(:current_user) { build :user }
  let(:student) { build :user }
  let(:client) { instance_double(Panoptes::Client) }
  let(:classroom) { create :classroom, teachers: [current_user], students: [student] }

  before { allow(client).to receive(:remove_user_from_user_group).and_return(true) }

  it 'destroys the student_user' do
    described_class.run! current_user: current_user, client: client, classroom_id: classroom.id, id: classroom.student_users.first.id
    expect(classroom.students.reload).to be_empty
  end

  it 'removes the user from the user group on panoptes' do
    described_class.run! current_user: current_user, client: client, classroom_id: classroom.id, id: classroom.student_users.first.id
    expect(client).to have_received(:remove_user_from_user_group).with(classroom.zooniverse_group_id, student.zooniverse_id).once
  end
end
