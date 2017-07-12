require 'spec_helper'

RSpec.describe Classrooms::TeacherUpdate do
  let(:current_user) { create(:user) }
  let(:client) { instance_double(Panoptes::Client) }
  let(:operation)    { described_class.with(current_user: current_user, client: client) }
  let(:classroom)    { create :classroom, teachers: [current_user] }

  it 'changes a classroom attributes', :aggregate_failures do
    result = operation.run! id: classroom.id, name: 'foobar', school: 'school-updated', subject: 'subject-updated'
    expect(result.name).to eq('foobar')
    expect(result.school).to eq('school-updated')
    expect(result.subject).to eq('subject-updated')
    expect(result.description).to eq('description-updated')
  end

  it 'is not valid when the current user is not a teacher of the classroom' do
    classroom.update! teachers: [create(:user)]
    outcome = operation.run id: classroom.id
    expect(outcome).not_to be_valid
  end
end
