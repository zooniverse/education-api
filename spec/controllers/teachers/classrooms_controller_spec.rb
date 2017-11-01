require 'rails_helper'

RSpec.describe Teachers::ClassroomsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET index" do
    let(:program) {create(:program)}

    it "returns an empty list if there are no classrooms" do
      get :index, params: { program_id: program.id }, format: :json
      expect(parsed_response).to eq("data" => [])
    end

    it 'returns the classrooms with students' do
      classroom = create :classroom, name: 'Foo', zooniverse_group_id: 'asdf', join_token: 'abc', teachers: [current_user], program: program
      student   = classroom.students.create! zooniverse_id: 'zoo1'

      get :index, params: { program_id: program.id }, format: :json
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new([classroom], include: [:students]).to_json)
    end

    it 'filters by program id' do
      program = create(:program)
      classroom = create :classroom, teachers: [current_user], program: program
      other_classroom = create :classroom
      get :index, params: { program_id: program.id }, format: :json
      expect(parsed_response).not_to include(other_classroom)
    end
  end

  describe "POST create" do
    let(:program) {create(:program)}
    it "creates a new classroom" do
      created_user_group = {'id' => 1, 'join_token' => 'asdf'}
      allow(user_client).to receive_message_chain(:panoptes, :post).with("/user_groups", user_groups: {name: an_instance_of(String)}).and_return("user_groups" => [created_user_group])
      relationships = {program: {data: {id: program.id, type: 'program'}}}
      post :create, params: {data: {attributes: {name: "Foo"}, relationships: relationships}}, format: :json

      classroom = Classroom.first
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end

  describe 'PUT update' do
    let(:classroom) { create :classroom, teachers: [current_user] }
    let(:outcome) { double(valid?: true, result: classroom) }

    it 'calls the operation' do
      expect(Classrooms::TeacherUpdate).to receive(:run).once.and_return(outcome)
      put :update, params: {id: classroom.id, data: {attributes: {name: "Foobar"}}}, format: :json
    end
  end
end
