require 'spec_helper'

RSpec.describe Assignments::Index do
  let(:current_user) { create :user }
  let(:client) { instance_double(Panoptes::Client, join_user_group: true) }
  let(:operation) { described_class.with(current_user: current_user, client: client) }

  it 'lists no assignments when there are none' do
    result = operation.run!
    expect(result).to be_empty
  end

  describe 'from taught classrooms' do
    it 'lists all assignments' do
      classroom = create :classroom, teachers: [current_user]
      assignment = create :assignment, classroom: classroom
      result = operation.run!
      expect(result).to eq([assignment])
    end

    it 'filters by classroom' do
      classroom1 = create :classroom, teachers: [current_user]
      assignment1 = create :assignment, classroom: classroom1
      classroom2 = create :classroom, teachers: [current_user]
      assignment2 = create :assignment, classroom: classroom2

      result = operation.run! classroom_id: classroom1.id
      expect(result).to eq([assignment1])
    end
  end

  describe 'from studied classrooms' do
    it 'lists assigned assignments' do
      other_user = create :user
      classroom = create :classroom, students: [current_user, other_user]
      assignment1 = create :assignment, classroom: classroom, student_users: [current_user.student_users.first]
      assignment2 = create :assignment, classroom: classroom, student_users: [other_user.student_users.first]

      result = operation.run!
      expect(result).to eq([assignment1])
    end

    it 'filters by classroom' do
      classroom1 = create :classroom, students: [current_user]
      assignment1 = create :assignment, classroom: classroom1, student_users: [current_user.student_users.first]
      classroom2 = create :classroom, students: [current_user]
      assignment2 = create :assignment, classroom: classroom2, student_users: [current_user.student_users.first]

      result = operation.run! classroom_id: classroom1.id
      expect(result).to eq([assignment1])
    end
  end
end
