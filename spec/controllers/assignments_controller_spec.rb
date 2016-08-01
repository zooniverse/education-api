require 'rails_helper'

RSpec.describe AssignmentsController do
  include AuthenticationHelpers

  before { authenticate! }

  let(:panoptes_application_client) do
    double(:panoptes_application_client)
  end

  describe "GET index" do
    it 'returns a list of assignments' do
      classroom  = create(:classroom, teachers: [current_user], students: [create(:user)])
      assignment = create(:assignment, classroom: classroom, student_users: classroom.student_users)
      get :index, format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new([assignment], include: [:student_assignments]).to_json)
    end
  end

  describe "POST create" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'returns a new assignment' do
      classroom  = create(:classroom, teachers: [current_user])
      assignment = build(:assignment, classroom: classroom)
      outcome = double(result: assignment, valid?: true)

      attributes = {name: "Foo"}
      relationships = {classroom: {data: {id: classroom.id, type: 'classrooms'}}}

      expect(Assignments::Create).to receive(:run)
        .with(current_user: current_user, panoptes: panoptes_application_client, attributes: attributes, relationships: relationships)
        .and_return(outcome)

      post :create, data: {attributes: attributes, relationships: relationships}, format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new(assignment, include: [:students]).to_json)
    end
  end

  describe "DELETE" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'marks the assignment as deleted' do
      classroom  = build(:classroom, teachers: [current_user])
      assignment = build(:assignment, id: 123, classroom: classroom)
      outcome = double(result: assignment, valid?: true)
      expect(Assignments::Destroy).to receive(:run)
        .with(a_hash_including(current_user: current_user, panoptes: panoptes_application_client, "id" => assignment.id.to_s))
        .and_return(outcome)
      delete :destroy, id: assignment.id, format: :json
      expect(response.status).to eq(204)
    end
  end
end
