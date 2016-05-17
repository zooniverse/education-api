require 'rails_helper'

RSpec.describe Students::ClassroomsController do
  let(:client) do
    double(Panoptes::Client, me: {"id" => "1", "login" => "login", "display_name" => "display_name"}).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
      allow(client).to receive(:join_user_group).with(nil, "1", join_token: "asdf").and_return(true)
    end
  end

  let(:parsed_response) do
    JSON.parse(response.body)
  end

  before do
    allow(controller).to receive(:panoptes).and_return(client)
  end

  describe "GET index"

  describe "POST join" do
    it "joins a classroom" do
      request.headers["Authorization"] = "Bearer xyz"
      classroom = Classroom.create! name: '1', join_token: 'asdf'
      post :join, id: classroom.id, join_token: 'asdf', format: :json
      expect(response.body).to eq(ActiveModel::SerializableResource.new(classroom, include: [:students]).to_json)
    end
  end
end
