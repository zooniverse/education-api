require 'rails_helper'

RSpec.describe Teachers::ClassroomsController do
  let(:client) do
    double(Panoptes::Client, me: {"id" => "1"}).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end
  end

  let(:parsed_response) do
    JSON.parse(response.body)
  end

  before do
    allow(controller).to receive(:panoptes).and_return(client)
  end

  describe "GET index" do
    it "returns an empty list if there are no classrooms" do
      request.headers["Authorization"] = "Bearer xyz"
      allow(client).to receive(:paginate).with("/user_groups", {}).and_return("user_groups" => [])
      get :index, format: :json
      expect(parsed_response).to eq("data" => [])
    end
  end
end
