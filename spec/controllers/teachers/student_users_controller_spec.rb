require 'rails_helper'

RSpec.describe Teachers::StudentUsersController do
  let(:client) do
    double(Panoptes::Client, me: {"id" => "1", "login" => "login", "display_name" => "display_name"}).tap do |client|
      allow(client).to receive(:is_a?).and_return(false)
      allow(client).to receive(:is_a?).with(Panoptes::Client).and_return(true)
    end
  end

  let(:current_user) do
    create :user
  end

  before do
    allow(controller).to receive(:panoptes).and_return(client)
  end

  describe 'DELETE destroy' do
    let(:classroom) { create :classroom, teachers: [current_user], students: [create(:user)] }
    let(:outcome) { double(valid?: true, result: classroom) }

    it 'calls the operation' do
      expect(StudentUsers::Destroy).to receive(:run).once.and_return(outcome)
      delete :destroy, classroom_id: classroom.id, id: classroom.student_users.first.id, format: :json
    end
  end
end
