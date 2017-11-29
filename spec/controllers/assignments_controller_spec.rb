require 'rails_helper'

RSpec.describe AssignmentsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET index" do
    it 'returns a list of assignments' do
      classroom  = create(:classroom, teachers: [current_user], students: [create(:user)])
      assignment = create(:assignment, classroom: classroom, student_users: classroom.student_users)
      get :index, format: :json
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new([assignment], include: [:student_assignments]).to_json)
    end
  end

  describe "POST create" do
    let(:workflow_id) { 8888 }

    before do
      allow(controller).to receive(:panoptes_application_client).and_return(application_client)
      allow(application_client).to receive(:workflow).and_return({"id"=> workflow_id, "links" => {"project" => "1"}})
    end

    it 'returns a new assignment' do
      program = create(:program)
      classroom  = create(:classroom, program: program, teachers: [current_user])
      assignment = build(:assignment, classroom: classroom)
      outcome = double(result: assignment, valid?: true)

      attributes = {workflow_id: workflow_id, name: "Foo"}
      relationships = {classroom: {data: {id: classroom.id, type: 'classrooms'}}}

      post :create, params: {data: {attributes: attributes, relationships: relationships}}, format: :json
      expect(response.status).to eq(201)
      expect(parsed_response[:data][:attributes][:name]).to eq(assignment.name)
    end
  end

  describe "DELETE" do
    before do
      allow(controller).to receive(:panoptes_application_client).and_return(application_client)
    end

    it 'marks the assignment as deleted' do
      classroom  = create(:classroom, teachers: [current_user])
      assignment = create(:assignment, id: 123, classroom: classroom)
      delete :destroy, params: {id: assignment.id}, format: :json
      expect(response.status).to eq(204)
      expect(Assignment.find(123).deleted_at).not_to be(nil)
    end
  end
end
