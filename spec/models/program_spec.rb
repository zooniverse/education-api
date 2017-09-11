require 'rails_helper'

RSpec.describe Program, type: :model do
  it 'requires a slug' do
    expect(build(:program, slug: nil)).to_not be_valid
  end
end
