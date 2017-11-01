require 'spec_helper'

RSpec.describe Classrooms::Join do
  let(:current_user) { create(:user) }
  let(:client) { instance_double(Panoptes::Client) }
  let(:classroom) { create(:classroom) }

  before { allow(client).to receive(:join_user_group).and_return(true) }

  it 'joins a student to a classroom' do
    described_class.run! current_user: current_user, client: client,
      id: classroom.id, join_token: classroom.join_token
    expect(classroom.students).to include(current_user)
  end

  it 'does not join if panoptes fails' do
    allow(client).to receive(:join_user_group).and_raise(Panoptes::Client::ServerError, "an error")
    outcome = described_class.run(current_user: current_user, client: client,
      id: classroom.id, join_token: classroom.join_token)

    expect(outcome).not_to be_valid
    expect(classroom.students).to be_empty
  end

  it 'joins a teacher to its own classroom without adding in panoptes' do
    classroom.teachers << current_user
    described_class.run! current_user: current_user, client: client,
      id: classroom.id, join_token: classroom.join_token
    expect(classroom.students).to include(current_user)
    expect(client).not_to have_received(:join_user_group)
  end

  describe "assignment assignment" do
    describe "custom programs" do
      let(:custom_program) { create(:program, custom: true) }
      let(:custom_classroom) { create(:classroom, program: custom_program) }
      let!(:custom_assignment) { create(:assignment, classroom: custom_classroom) }

      it "doesn't affect assignments" do
        expect{
          outcome = described_class.run!(current_user: current_user, client: client,
            id: classroom.id, join_token: classroom.join_token)
        }.to_not change{ custom_assignment.student_users }
      end
    end

    describe "standard programs" do
      let!(:standard_assignment) { create(:assignment, classroom: classroom) }

      it "adds the user to all assignments" do
        outcome = described_class.run!(current_user: current_user, client: client,
          id: classroom.id, join_token: classroom.join_token)
        expect(standard_assignment.student_users.map {|su| su.user_id }).to include(current_user.id)
      end
    end
  end
end
