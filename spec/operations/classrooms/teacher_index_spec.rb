require 'spec_helper'

RSpec.describe Classrooms::TeacherIndex do
  let(:current_user) { create :user }
  let(:client) { instance_double(Panoptes::Client) }
  let(:operation) { described_class.with(current_user: current_user, client: client) }

  it 'returns classrooms the current user is a teacher of' do
    classroom = create :classroom, teachers: [current_user]
    classrooms = operation.run!
    expect(classrooms).to include(classroom)
  end

  it 'does not return deleted classrooms' do
    classroom = create :classroom, :deleted, teachers: [current_user]
    classrooms = operation.run!
    expect(classrooms).not_to include(classroom)
  end

  it 'filters by program id' do
    program = create(:program)
    classroom = create :classroom, teachers: [current_user]
    program_classroom = create :classroom, teachers: [current_user], program: program
    result = operation.run! program_id: program.id
    expect(result).to include(program_classroom)
    expect(result).not_to include(classroom)
  end
end
