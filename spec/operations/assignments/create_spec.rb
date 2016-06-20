require 'spec_helper'

RSpec.describe Assignments::Create do
  let(:current_user) { create :user }
  let(:panoptes) { instance_double(Panoptes::Client, join_user_group: true) }
  let(:operation) { described_class.with(current_user: current_user, panoptes: panoptes) }
  let(:classroom) { create :classroom, teachers: [current_user] }

  before do
    allow(panoptes).to receive(:workflow).and_return("links" => {"project" => "1"})
    allow(panoptes).to receive(:create_workflow).and_return("id" => "2", "links" => {"project" => "1"})
    allow(panoptes).to receive(:create_subject_set).and_return("id" => "123")
  end

  it 'creates a new subject set' do
    expect(panoptes).to receive(:create_subject_set).and_return("id" => "123")
    operation.run! name: 'foo', classroom_id: classroom.id
  end

  it 'creates a new workflow' do
    expect(panoptes).to receive(:create_workflow)
                    .with("display_name" => an_instance_of(String),
                          "retirement" => {criteria: "never", options: {}},
                          "links" => {project: "1", subject_sets: ["123"]})
                    .and_return("id" => "2")
    operation.run! name: 'foo', classroom_id: classroom.id
  end

  it 'creates an assignment' do
    assignment = operation.run! name: 'foo', classroom_id: classroom.id
    expect(classroom.assignments.count).to eq(1)
    expect(classroom.assignments.first).to eq(assignment)
  end
end
