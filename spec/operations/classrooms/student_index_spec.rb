require 'spec_helper'

RSpec.describe Classrooms::StudentIndex do
  let(:current_user) { User.new zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client, join_user_group: true) }
  let(:classroom) { create(:classroom, join_token: 'abc', zooniverse_group_id: "asdf") }

  it 'returns classrooms the current user is a student of' do
    Classrooms::Join.run! current_user: current_user, client: client, id: classroom.id, join_token: classroom.join_token
    classrooms = described_class.run! current_user: current_user, client: client, program_id: classroom.program.id
    expect(classrooms).to include(classroom)
  end

  it 'does not return classrooms the current user is a teacher of' do
    panoptes_client = instance_double(Panoptes::Endpoints::JsonApiEndpoint, post: {'user_groups' => [{'id' => '1', 'join_token' => 'asdf'}]})
    allow(client).to receive(:panoptes).and_return(panoptes_client)
    classroom.teachers << current_user
    classrooms = described_class.run! current_user: current_user, client: client, program_id: classroom.program.id
    expect(classrooms).not_to include(classroom)
  end
end
