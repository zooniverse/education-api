require 'rails_helper'

RSpec.describe ProgramsController do
  include AuthenticationHelpers

  before { authenticate! }

  let(:panoptes_application_client) do
    double(:panoptes_application_client)
  end

  describe "POST create" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'returns a new program' do
      program = build(:program)
      outcome = double(result: program, valid?: true)
      attributes = {slug: program.slug, name: program.name}

      # Why is this spec busted?
      # rebuilt = {}.tap do |param|
      #   param[:attributes] = attributes
      #   param[:current_user] = current_user
      #   param[:client] = panoptes_application_client
      # end
      # action_params = ActionController::Parameters.new(rebuilt)

      # expect(Programs::Create).to receive(:run)
      #   .with(action_params)
      #   .and_return(outcome)

      post :create, params: {data: {attributes: attributes}}, as: :json
      expect(parsed_response[:slug]).to eq(program.slug)
    end
  end

  describe "PUT update" do
    let(:new_name) { "A new and exciting name" }

    it 'returns a new program' do
      program = create(:program)
      outcome = double(result: program, valid?: true)
      attributes = {name: new_name}

      # Why is this spec busted?
      # params = {}.tap do |param|
      #   param[:attributes] = attributes
      #   param[:current_user] = current_user
      #   param[:client] = panoptes_application_client
      # end
      # action_params = ActionController::Parameters.new(params)

      # expect(Programs::Update).to receive(:run)
      #   .with(action_params)
      #   .and_return(outcome)

      put :update, params: {id: program.id, data: {attributes: attributes}}, as: :json
      expect(response.status).to eq(204)
      expect(program.reload.name).to eq(new_name)
    end
  end
end
