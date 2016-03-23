require 'rails_helper'

RSpec.describe UsersController do
  let(:client) do
    double(Panoptes::Client, me: {"id" => "1", "login" => "login", "display_name" => "display_name"}).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end
  end

  let(:parsed_response) do
    JSON.parse(response.body)
  end

  let(:current_user) { User.create! zooniverse_id: "1" }

  before do
    allow(controller).to receive(:panoptes).and_return(client)
  end

  describe "PUT update" do
    it "updates the current user" do
      request.headers["Authorization"] = "Bearer xyz"
      put :update, id: current_user.zooniverse_id, data: {attributes: {metadata: {"foo" => "bar"}}}, format: :json
      expect(response.status).to eq(204)
      expect(current_user.reload.metadata).to eq("foo" => "bar")
    end

    it 'does not allow updating other users' do
      other_user = User.create! zooniverse_id: '2'
      request.headers["Authorization"] = "Bearer xyz"
      put :update, id: other_user.zooniverse_id, data: {attributes: {metadata: {"foo" => "bar"}}}, format: :json
      expect(response.status).to eq(403)
    end
  end
end
