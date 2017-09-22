require 'rails_helper'

RSpec.describe Students::ClassroomsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET index" do
    it 'filters by program id' do
      program = create(:program)
      classroom = create :classroom, teachers: [current_user], program: program
      other_classroom = create :classroom
      get :index, params: { program_id: program.id }, format: :json
      expect(parsed_response).not_to include(other_classroom)
    end
  end

  describe "POST join" do
    it "joins a classroom" do
      expect(client).to receive(:join_user_group).with(nil, "9999", join_token: "asdf").and_return(true)
      classroom = Classroom.create! name: '1', join_token: 'asdf'
      post :join, params: {id: classroom.id, join_token: 'asdf'}, as: :json
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end
end
