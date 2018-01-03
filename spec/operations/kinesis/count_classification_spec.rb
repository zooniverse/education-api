require 'spec_helper'

RSpec.describe Kinesis::CountClassification do
  let(:payload) { JSON.load(File.read(Rails.root.join("spec/fixtures/example_kinesis_payload.json"))) }
  let(:operation) { described_class.with(payload) }

  let(:payload_sans_user_group) { payload.tap { |p| p["data"]["metadata"].delete("user_group") } }
  let(:operation_sans_user_group) { described_class.with(payload_sans_user_group) }

  let(:student)   { create :user, zooniverse_id: "1234" }
  let(:classroom) { create :classroom, zooniverse_group_id: "1234", students: [student] }

  context "with user group" do
    it 'increments counter for the classroom' do
      expect { operation.run! }.to change { classroom.reload.classifications_count }.from(0).to(1)
    end

    it 'increments counter for a student' do
      expect { operation.run! }.to change { classroom.student_users.first.reload.classifications_count }.from(0).to(1)
    end

    it 'increments counter for a student in an assignment' do
      create :assignment, classroom: classroom, student_users: classroom.student_users, workflow_id: "4378"
      expect { operation.run! }.to change { classroom.student_users.first.student_assignments.first.reload.classifications_count }.from(0).to(1)
    end
  end

  context "without user group" do
    it 'increments counter for the classroom' do
      expect { operation_sans_user_group.run! }.to change { classroom.reload.classifications_count }.from(0).to(1)
    end

    it 'increments counter for a student' do
      expect { operation_sans_user_group.run! }.to change { classroom.student_users.first.reload.classifications_count }.from(0).to(1)
    end

    it 'increments counter for a student in an assignment' do
      create :assignment, classroom: classroom, student_users: classroom.student_users, workflow_id: "4378"
      expect { operation_sans_user_group.run! }.to change { classroom.student_users.first.student_assignments.first.reload.classifications_count }.from(0).to(1)
    end
  end
end
