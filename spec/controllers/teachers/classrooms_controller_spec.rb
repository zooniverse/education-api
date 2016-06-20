require 'rails_helper'

RSpec.describe Teachers::ClassroomsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET index" do
    it "returns an empty list if there are no classrooms" do
      allow(panoptes_client).to receive(:paginate).with("/user_groups", {}).and_return("user_groups" => [])
      get :index, format: :json
      expect(parsed_response).to eq("data" => [])
    end

    it 'returns the classrooms with students' do
      classroom = create :classroom, name: 'Foo', zooniverse_group_id: 'asdf', join_token: 'abc', teachers: [current_user]
      student   = classroom.students.create! zooniverse_id: 'zoo1'

      get :index, format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new([classroom], include: [:students]).to_json)
    end
  end

  describe "POST create" do
    it "creates a new classroom" do
      created_user_group = {'id' => 1, 'join_token' => 'asdf'}
      allow(panoptes_client).to receive(:post).with("/user_groups", user_groups: {name: an_instance_of(String)}).and_return("user_groups" => [created_user_group])
      post :create, data: {attributes: {name: "Foo"}}, format: :json

      classroom = Classroom.first
      expect(response.body).to eq(ActiveModel::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end

  describe 'PUT update' do
    let(:classroom) { create :classroom, teachers: [current_user] }
    let(:outcome) { double(valid?: true, result: classroom) }

    it 'calls the operation' do
      expect(Classrooms::TeacherUpdate).to receive(:run).once.and_return(outcome)
      put :update, id: classroom.id, data: {attributes: {name: "Foobar"}}, format: :json
    end
  end
end
