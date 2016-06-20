require 'rails_helper'

RSpec.describe Students::ClassroomsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET index"

  describe "POST join" do
    it "joins a classroom" do
      expect(panoptes_client).to receive(:join_user_group).with(nil, "1", join_token: "asdf").and_return(true)
      classroom = Classroom.create! name: '1', join_token: 'asdf'
      post :join, id: classroom.id, join_token: 'asdf', format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end
end
