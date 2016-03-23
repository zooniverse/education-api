require 'rails_helper'

RSpec.describe CartoUploader, type: :model do
  let(:uploader) { described_class.new }
  
  it 'processes a classification' do
    line = {"annotations" => "{}"}
    uploader.process(line)
    uploader.finalize
    binding.pry
    #    expect(something).to happen
  end
end
