require 'spec_helper'

RSpec.describe Assignments::Destroy do
  let(:current_user) { build :user }
  let(:client) { instance_double(Panoptes::Client) }
  let(:classroom) { create :classroom, teachers: [current_user] }
  let(:assignment) { create :assignment, classroom: classroom }
  let(:operation) { described_class.with(current_user: current_user, client: client) }

  it 'marks the assignment as deleted' do
    operation.run! id: assignment.id
    expect(assignment.reload).to be_deleted
  end

  it 'is not valid when the current user is not a teacher of the assignment' do
    classroom.teachers = []
    classroom.save!
    outcome = operation.run
    expect(outcome).not_to be_valid
    expect(outcome.result).to be_nil
  end
end
