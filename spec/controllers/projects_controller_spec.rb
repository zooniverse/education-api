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
      attributes = {id: "1234", slug: "zooniverse/new-project"}
      project = build(:project, id: 1234)
      outcome = double(result: project, valid?: true)
      allow(panoptes_application_client).to receive(:project).and_return({id: "1234"})

      expect(Projects::Create).to receive(:run)
        .with(current_user: current_user, client: panoptes_application_client, attributes: attributes)
        .and_return(outcome)

      post :create, params: {data: {attributes: attributes}}, as: :json
    end
  end
end
