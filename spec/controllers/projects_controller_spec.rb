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
      attributes = {slug: project.slug}
      outcome = double(result: project, valid?: true)
      allow(panoptes_application_client).to receive(:project).and_return({id: "1234"})

      # Why is this spec busted?
      # expect(Projects::Create).to receive(:run).once
      #   .with(current_user: current_user, client: panoptes_application_client, attributes: attributes)
      #   .and_return(project)

      post :create, params: {data: {attributes: attributes}}, as: :json
      expect(response.body).to include(ActiveModelSerializers::SerializableResource.new(project).to_json)
    end
  end

  describe "PUT update" do
    before { allow(controller).to receive(:panoptes_application_client).and_return(panoptes_application_client) }

    it 'returns a new project' do
      project = create(:project)
      attributes = {clone_workflow: true}

      # Why is this spec busted?
      # expect(Projects::Update).to receive(:run).once
        # .with(current_user: current_user, client: panoptes_application_client, attributes: attributes)
        # .and_return(outcome)

      put :update, params: {id: project.id, data: {attributes: attributes}}, as: :json
      expect(response.status).to eq(204)
      expect(project.reload.clone_workflow).to be true
    end
  end
end
