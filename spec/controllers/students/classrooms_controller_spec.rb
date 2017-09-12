require 'rails_helper'

RSpec.describe Students::ClassroomsController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "POST join" do
    it "joins a classroom" do
      expect(client).to receive(:join_user_group).with(nil, "9999", join_token: "asdf").and_return(true)
      classroom = Classroom.create! name: '1', join_token: 'asdf'
      post :join, params: {id: classroom.id, join_token: 'asdf'}, as: :json
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end
end
