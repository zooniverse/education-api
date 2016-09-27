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
    allow(panoptes).to receive(:add_subjects_to_subject_set).and_return(true)
  end

  it 'creates a new subject set' do
    expect(panoptes).to receive(:create_subject_set).and_return("id" => "123")
    operation.run! attributes: {name: 'foo'},
                   relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
  end

  it 'creates a new workflow' do
    expect(panoptes).to receive(:create_workflow)
                    .with("display_name" => an_instance_of(String),
                          "retirement" => {criteria: "never_retire", options: {}},
                          "links" => {project: "1", subject_sets: ["123"]})
                    .and_return("id" => "2")
    operation.run! attributes: {name: 'foo'},
                   relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
  end

  it 'creates an assignment' do
    metadata = { "fake" => "data" }
    assignment = operation.run! attributes: { name: "foo", metadata: metadata },
                                relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}}}
    expect(classroom.assignments.count).to eq(1)
    expect(classroom.assignments.first).to eq(assignment)
    expect(classroom.assignments.first.attributes["metadata"]).to eq(metadata)
  end

  it 'links students' do
    student_user1 = create :student_user, user: create(:user), classroom: classroom
    student_user2 = create :student_user, user: create(:user), classroom: classroom

    assignment = operation.run! attributes: {name: 'foo'},
                                relationships: {classroom: {data: {id: classroom.id, type: 'classrooms'}},
                                                student_users: {data: [{id: student_user1.id, type: 'student_user'},
                                                                       {id: student_user2.id, type: 'student_user'}]}}
    expect(assignment.student_users).to match_array([student_user1, student_user2])
  end
end
