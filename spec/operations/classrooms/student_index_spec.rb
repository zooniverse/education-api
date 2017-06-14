require 'spec_helper'

RSpec.describe Classrooms::StudentIndex do
  let(:current_user) { User.new zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }
  let(:classroom) { Classroom.create! join_token: 'abc', zooniverse_group_id: "asdf" }

  it 'returns classrooms the current user is a student of' do
    allow(client).to receive_message_chain(:panoptes, :paginate).and_return({"user_groups" => [{"id" => classroom.zooniverse_group_id}]})
    allow(client).to receive(:join_user_group).and_return(true)

    Classrooms::Join.run! current_user: current_user, client: client, id: classroom.id, join_token: classroom.join_token
    classrooms = described_class.run! current_user: current_user, client: client
    expect(classrooms).to include(classroom)
  end

  it 'does not return classrooms the current user is a teacher of' do
    allow(client).to receive_message_chain(:panoptes, :post).and_return({"user_groups" => [{"id" => classroom.zooniverse_group_id, "join_token" => classroom.join_token}]})
    allow(client).to receive_message_chain(:panoptes, :paginate).and_return({"user_groups" => [{"id" => classroom.zooniverse_group_id}]})

    Classrooms::TeacherCreate.run! current_user: current_user, client: client, id: classroom.id, name: 'foo'
    classrooms = described_class.run! current_user: current_user, client: client
    expect(classrooms).not_to include(classroom)
  end
end
