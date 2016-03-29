require 'spec_helper'

RSpec.describe Classrooms::StudentIndex do
  let(:current_user) { User.new zooniverse_id: 1 }
  let(:panoptes) { instance_double(Panoptes::Client, join_user_group: true) }
  let(:classroom) { Classroom.create! join_token: 'abc', zooniverse_group_id: "asdf" }

  it 'returns classrooms the current user is a student of' do
    allow(panoptes).to receive(:paginate).and_return({"user_groups" => [{"id" => classroom.zooniverse_group_id}]})
    Classrooms::Join.run! current_user: current_user, panoptes: panoptes, id: classroom.id, join_token: classroom.join_token
    classrooms = described_class.run! current_user: current_user, panoptes: panoptes
    expect(classrooms).to include(classroom)
  end

  it 'does not return classrooms the current user is a teacher of' do
    allow(panoptes).to receive(:post).and_return({"user_groups" => [{"id" => classroom.zooniverse_group_id, "join_token" => classroom.join_token}]})
    allow(panoptes).to receive(:paginate).and_return({"user_groups" => [{"id" => classroom.zooniverse_group_id}]})
    Classrooms::TeacherCreate.run! current_user: current_user, panoptes: panoptes, id: classroom.id, name: 'foo'
    classrooms = described_class.run! current_user: current_user, panoptes: panoptes
    expect(classrooms).not_to include(classroom)
  end
end
