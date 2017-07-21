require 'rails_helper'

RSpec.describe ProjectsController do
  include AuthenticationHelpers

  before { authenticate! }

  let(:panoptes_application_client) do
    double(:panoptes_application_client)
  end

  describe "POST create" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'returns a new project' do
      project = build(:project, id: 1234)
      outcome = double(result: project, valid?: true)
      attributes = {slug: project.slug}
      op_attributes = attributes.merge(id: "1234")
      allow(panoptes_application_client).to receive(:project).and_return({id: "1234"})

      rebuilt = {}.tap do |param|
        param[:attributes] = op_attributes
        param[:current_user] = current_user
        param[:client] = panoptes_application_client
      end
      action_params = ActionController::Parameters.new(rebuilt)

      # Why is this spec busted?
      # expect(Projects::Create).to receive(:run)
      #   .with(action_params)
      #   .and_return(outcome)

      post :create, params: {data: {attributes: attributes}}, as: :json
      expect(response.body).to include(ActiveModelSerializers::SerializableResource.new(project).to_json)
    end
  end

  describe "PUT update" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'returns a new project' do
      project = create(:project)
      outcome = double(result: project, valid?: true)
      attributes = {custom_subject_set: true}

      params = {}.tap do |param|
        param[:attributes] = attributes
        param[:current_user] = current_user
        param[:client] = panoptes_application_client
      end
      action_params = ActionController::Parameters.new(params)

      # Why is this spec busted?
      # expect(Projects::Update).to receive(:run)
      #   .with(action_params)
      #   .and_return(outcome)

      put :update, params: {id: project.id, data: {attributes: attributes}}, as: :json
      expect(response.status).to eq(204)
      expect(project.reload.custom_subject_set).to be true
    end
  end
end
