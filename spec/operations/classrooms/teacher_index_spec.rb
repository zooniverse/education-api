require 'spec_helper'

RSpec.describe Classrooms::TeacherIndex do
  let(:current_user) { create :user }
  let(:panoptes) { instance_double(Panoptes::Client, join_user_group: true) }

  it 'returns classrooms the current user is a teacher of' do
    classroom = create :classroom, teachers: [current_user]
    classrooms = described_class.run! current_user: current_user, panoptes: panoptes
    expect(classrooms).to include(classroom)
  end

  it 'does not return deleted classrooms' do
    classroom = create :classroom, :deleted, teachers: [current_user]
    classrooms = described_class.run! current_user: current_user, panoptes: panoptes
    expect(classrooms).not_to include(classroom)
  end
end
