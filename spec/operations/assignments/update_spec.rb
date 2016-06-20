require 'spec_helper'

RSpec.describe Assignments::Update do
  let(:current_user) { build :user }
  let(:panoptes) { instance_double(Panoptes::Client) }
  let(:classroom) { create :classroom, teachers: [current_user] }
  let(:assignment) { create :assignment, classroom: classroom }
  let(:operation) { described_class.with(current_user: current_user, panoptes: panoptes) }

  it 'updates name' do
    operation.run! id: assignment.id, attributes: {name: 'bar'}
    expect(assignment.reload.name).to eq('bar')
  end

  it 'does not update name when nothing given' do
    assignment.update! name: 'foo'
    expect { operation.run! id: assignment.id }.not_to change { assignment.reload.name }
  end

  it 'updates metadata' do
    metadata = {foo: 1, bar: 'baz'}
    operation.run! id: assignment.id, attributes: {metadata: metadata}
    expect(assignment.reload.metadata).to eq(metadata.stringify_keys)
  end

  it 'does not update metadata when nothing given' do
    assignment.update! attributes: {metadata: {foo: 1}}
    expect { operation.run! id: assignment.id }.not_to change { assignment.reload.metadata }
  end

  it 'is not valid when the current user is not a teacher of the assignment' do
    classroom.teachers = []
    classroom.save!
    outcome = operation.run
    expect(outcome).not_to be_valid
    expect(outcome.result).to be_nil
  end

  it 'links students' do
    student_user1 = create :student_user, user: create(:user), classroom: classroom
    student_user2 = create :student_user, user: create(:user), classroom: classroom

    operation.run! id: assignment.id,
                   attributes: {name: 'foo'},
                   relationships: {student_users: {data: [{id: student_user1.id, type: 'student_user'},
                                                          {id: student_user2.id, type: 'student_user'}]}}
    expect(assignment.student_users).to match_array([student_user1, student_user2])
  end
end
