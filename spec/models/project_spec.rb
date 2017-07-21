require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'requires a slug' do
    expect(build(:project, slug: nil)).to_not be_valid
  end
end
