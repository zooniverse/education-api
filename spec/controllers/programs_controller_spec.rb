require 'rails_helper'

RSpec.describe ProgramsController do
  include AuthenticationHelpers

  before { authenticate! }

  let(:panoptes_application_client) do
    double(:panoptes_application_client)
  end

  describe "GET methods" do
    let!(:program) { create(:program) }
    it 'GET index returns a list of programs' do
      get :index, format: :json
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new([program]).to_json)
    end

    it 'GET show returns a single program' do
      get :show, params: {id: program.id}, format: :json
      expect(response.status).to eq(200)
      expect(response.body).to eq(ActiveModelSerializers::SerializableResource.new(program).to_json)
    end
  end

  describe "POST create" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'returns a new program' do
      program = build(:program)
      attributes = {slug: program.slug, name: program.name}

      post :create, params: {data: {attributes: attributes}}, format: :json
      expect(parsed_response[:data][:attributes][:slug]).to eq(program.slug)
    end
  end
end
