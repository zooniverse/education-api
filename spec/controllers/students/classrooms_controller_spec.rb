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
    let(:classroom) { create(:classroom) }
    it "joins a classroom" do
      expect(user_client).to receive(:join_user_group).with(classroom.zooniverse_group_id, current_user.zooniverse_id, join_token: classroom.join_token).and_return(true)
      post :join, params: {id: classroom.id, join_token: classroom.join_token}, as: :json
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end
end
