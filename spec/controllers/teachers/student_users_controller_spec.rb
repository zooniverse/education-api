require 'rails_helper'

RSpec.describe Teachers::StudentUsersController do
  include AuthenticationHelpers

  before { authenticate! }

  describe 'DELETE destroy' do
    let(:classroom) { create :classroom, teachers: [current_user], students: [create(:user)] }
    let(:outcome) { double(valid?: true, result: classroom) }

    it 'calls the operation' do
      expect(StudentUsers::Destroy).to receive(:run).once.and_return(outcome)
      delete :destroy, params: {classroom_id: classroom.id, id: classroom.student_users.first.id}, format: :json
    end
  end
end
