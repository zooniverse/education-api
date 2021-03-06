require 'spec_helper'

RSpec.describe Classrooms::TeacherIndex do
  let(:current_user) { create :user }
  let(:client) { instance_double(Panoptes::Client) }
  let(:operation) { described_class.with(current_user: current_user, client: client) }

  it 'returns classrooms the current user is a teacher of' do
    classroom = create :classroom, teachers: [current_user]
    classrooms = operation.run! program_id: classroom.program.id
    expect(classrooms).to include(classroom)
  end

  it 'does not return deleted classrooms' do
    classroom = create :classroom, :deleted, teachers: [current_user]
    classrooms = operation.run! program_id: classroom.program.id
    expect(classrooms).not_to include(classroom)
  end

  it 'filters by program id' do
    new_program = create(:program)
    classroom = create :classroom, teachers: [current_user]
    new_program_classroom = create :classroom, teachers: [current_user], program: new_program
    result = operation.run! program_id: new_program.id
    expect(result).to include(new_program_classroom)
    expect(result).not_to include(classroom)
  end
end
