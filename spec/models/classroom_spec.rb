require 'rails_helper'

RSpec.describe Classroom, type: :model do
  describe '#taught_by?' do
    it 'returns true if one of the teachers is the given user' do
      teachers = create_list(:user, 3)
      classroom = create(:classroom, teachers: teachers)
      expect(classroom.taught_by?(teachers.last)).to be_truthy
    end

    it 'returns false if none of the teachers is the given user' do
      user = create :user
      teachers = create_list(:user, 3)
      classroom = create(:classroom, teachers: teachers)
      expect(classroom.taught_by?(user)).to be_falsey
    end

    it 'returns false if there are no teachers' do
      user = create :user
      classroom = create(:classroom, teachers: [])
      expect(classroom.taught_by?(user)).to be_falsey

    end
  end
end
