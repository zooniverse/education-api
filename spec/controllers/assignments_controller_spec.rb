require 'rails_helper'

RSpec.describe AssignmentsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET index" do
    it 'returns a list of assignments' do
      classroom  = create(:classroom, teachers: [current_user])
      assignment = create(:assignment, classroom: classroom)
      get :index, format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new([assignment]).to_json)
    end
  end

  describe "POST create" do
    it 'returns a new assignment' do
      classroom  = create(:classroom, teachers: [current_user])
      assignment = build(:assignment, classroom: classroom)
      outcome = double(result: assignment, valid?: true)
      expect(Assignments::Create).to receive(:run)
        .with(current_user: current_user, panoptes: panoptes_client, classroom_id: classroom.id, attributes: {name: "Foo"})
        .and_return(outcome)
      post :create, classroom_id: classroom.id, data: {attributes: {name: "Foo"}}, format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new(assignment, include: [:students]).to_json)
    end
  end

  describe "DELETE" do
    it 'marks the assignment as deleted' do
      classroom  = build(:classroom, teachers: [current_user])
      assignment = build(:assignment, id: 123, classroom: classroom)
      outcome = double(result: assignment, valid?: true)
      expect(Assignments::Destroy).to receive(:run)
        .with(a_hash_including("current_user" => current_user, "panoptes" => panoptes_client, "id" => assignment.id.to_s))
        .and_return(outcome)
      delete :destroy, id: assignment.id, format: :json
      expect(response.status).to eq(204)
    end
  end
end
