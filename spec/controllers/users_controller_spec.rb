require 'rails_helper'

RSpec.describe UsersController do
  include AuthenticationHelpers

  before { authenticate! }

  describe "GET show" do
    it "returns the current user" do
      request.headers["Authorization"] = "Bearer xyz"
      get :show, params: {id: current_user.zooniverse_id}, format: :json
      expect(response.status).to eq(200)
    end

    it 'does not allow updating other users' do
      other_user = create(:user, zooniverse_id: "2")
      request.headers["Authorization"] = "Bearer xyz"
      get :show, params: {id: other_user.zooniverse_id}, format: :json
      expect(response.status).to eq(403)
    end

  end

  describe "PUT update" do
    it "updates the current user" do
      request.headers["Authorization"] = "Bearer xyz"
      put :update, params: {id: current_user.zooniverse_id, data: {attributes: {metadata: {"foo" => "bar"}}}}, format: :json
      expect(response.status).to eq(204)
      expect(current_user.reload.metadata).to eq("foo" => "bar")
    end

    it 'does not allow updating other users' do
      other_user = User.create! zooniverse_id: '2'
      request.headers["Authorization"] = "Bearer xyz"
      put :update, params: {id: other_user.zooniverse_id, data: {attributes: {metadata: {"foo" => "bar"}}}}, format: :json
      expect(response.status).to eq(403)
    end
  end
end
