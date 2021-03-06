require 'spec_helper'

RSpec.describe Assignments::Create do
  let(:current_user) { create :user }
  let(:client) { instance_double(Panoptes::Client) }
  let(:operation) { described_class.with(current_user: current_user, client: client) }

  let(:classroom) { create :classroom, teachers: [current_user] }

  let(:custom_program) { create(:program, custom: true) }
  let(:custom_classroom) { create :classroom, teachers: [current_user], program: custom_program }

  let(:programless_classroom) { create :classroom, teachers: [current_user], program: nil}

  let(:workflow_id) { 999 }
  let(:cloned_workflow_id) { 123 }
  let(:cloned_workflow) {
    {
     "id" => cloned_workflow_id,
     "links" => {"project" => "1"}
    }
  }

  before do
    allow(client).to receive(:workflow).and_return({"id"=> workflow_id, "links" => {"project" => "1"}})
    allow(client).to receive(:create_workflow).and_return(cloned_workflow)
    allow(client).to receive(:create_subject_set).and_return("id" => "123")
    allow(client).to receive(:add_subject_set_to_workflow).and_return("id" => "123")
    allow(client).to receive(:add_subjects_to_subject_set).and_return(true)
  end

  describe "program uses a custom subject set and workflow" do
    it 'creates a new subject set' do
      expect(client).to receive(:create_subject_set).and_return("id" => "123")
      operation.run!  attributes: {workflow_id: workflow_id, name: 'foo'},
                      relationships: {classroom: {data: {id: custom_classroom.id, type: 'classrooms'}}}
    end

    it 'clones the workflow' do
      expect(client).to receive(:create_workflow)
                      .with("display_name" => an_instance_of(String),
                            "retirement" => {criteria: "never_retire", options: {}},
                            "serialize_with_project" => false,
                            "links" => {project: "1"})
                      .and_return(cloned_workflow)
      operation.run!  attributes: {workflow_id: workflow_id, name: 'foo'},
                      relationships: {classroom: {data: {id: custom_classroom.id, type: 'classrooms'}}}
    end
  end

  describe "program uses static workflow and subject sets" do
    it 'does not create a new subject set if false' do
      operation.run!  attributes: {workflow_id: workflow_id, name: 'foo'},
                      relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
      expect(classroom.assignments.first.subject_set_id).to be_nil
    end

    it "raises an error if a workflow is not included" do
      expect {
        operation.run!  attributes: {name: 'foo'},
                        relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
      }.to raise_error ActiveInteraction::InvalidInteractionError
    end

    it "does not create a new workflow" do
      operation.run!  attributes: {workflow_id: workflow_id, name: 'foo'},
                      relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
      expect(classroom.assignments.first.workflow_id).to eq("999")
    end
  end

  it 'creates an assignment' do
    metadata = { "fake" => "data" }
    assignment = operation.run!   attributes: { workflow_id: workflow_id, name: "foo", metadata: metadata },
                                  relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
    expect(classroom.assignments.count).to eq(1)
    expect(classroom.assignments.first).to eq(assignment)
    expect(classroom.assignments.first.attributes["metadata"]).to eq(metadata)
  end

  it 'links students' do
    student_user1 = create :student_user, user: create(:user), classroom: classroom
    student_user2 = create :student_user, user: create(:user), classroom: classroom

    assignment = operation.run! attributes: {workflow_id: workflow_id, name: 'foo'},
                                relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}},
                                                student_users: {data: [{id: student_user1.id, type: 'student_user'},
                                                                       {id: student_user2.id, type: 'student_user'}]}}
    expect(assignment.student_users).to match_array([student_user1, student_user2])
  end
end
