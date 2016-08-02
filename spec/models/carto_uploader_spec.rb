require 'spec_helper'

RSpec.describe CartoUploader, type: :model do
  let(:cartodb) { double(account: "foo") }
  let(:uploader) { described_class.new(cartodb) }

  let(:item) do
    {
      classification_id:     123,
      user_name:             "martenveldthuis",
      user_group_ids:        [1,2,3,4],
      subject_id:            123,
      gorongosa_id:          'gorongongong',
      classified_at:         Time.local(2012,1,2,5,12,0),
      species:               "Baboon",
      species_count:         "12",
      species_young:         true,
      species_moving:        false,
      species_resting:       false,
      species_standing:      false,
      species_eating:        false,
      species_interacting:   false,
      species_horns:         true
    }
  end

  before do
    allow(cartodb).to receive(:get).with("SELECT classification_id FROM classifications ORDER BY classification_id DESC LIMIT 1").and_return("rows" => [])
    allow(cartodb).to receive(:get).with("TRUNCATE classifications").and_return("rows" => [])
  end

  it 'processes data' do
    expect(cartodb).to receive(:post).with("INSERT INTO classifications (classification_id,user_name,user_group_ids,subject_id,gorongosa_id,classified_at,species,species_count,species_young,species_moving,species_resting,species_standing,species_eating,species_interacting,species_horns) VALUES ('123','martenveldthuis','[1, 2, 3, 4]','123','gorongongong','2012-01-02 05:12:00 +0000','Baboon','12','true','false','false','false','false','false','true') ").once.and_return("total_rows" => 1)
    uploader.upload([item])
  end
end
