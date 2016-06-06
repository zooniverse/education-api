require 'spec_helper'

RSpec.describe Classrooms::Join do
  let(:current_user) { build :user }
  let(:panoptes) { instance_double(Panoptes::Client, join_user_group: true) }
  let(:classroom) { create :classroom }

  it 'joins a student to a classroom' do
    described_class.run! current_user: current_user, panoptes: panoptes,
      id: classroom.id, join_token: classroom.join_token
    expect(classroom.students(true)).to include(current_user)
  end

  it 'does not join if panoptes fails' do
    allow(panoptes).to receive(:join_user_group).and_raise(Panoptes::Client::ServerError, "an error")
    outcome = described_class.run(current_user: current_user, panoptes: panoptes,
      id: classroom.id, join_token: classroom.join_token)

    expect(outcome).not_to be_valid
    expect(classroom.students(true)).to be_empty
  end

  it 'joins a teacher to its own classroom without adding in panoptes' do
    classroom.teachers << current_user
    described_class.run! current_user: current_user, panoptes: panoptes,
      id: classroom.id, join_token: classroom.join_token
    expect(classroom.students(true)).to include(current_user)
    expect(panoptes).not_to have_received(:join_user_group)
  end
end
