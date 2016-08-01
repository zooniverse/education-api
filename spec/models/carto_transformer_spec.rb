require 'rails_helper'

RSpec.describe CartoTransformer, type: :model do
  let(:carto_uploader) { double("Carto", upload: nil) }
  let(:transformer) { described_class.new(carto: carto_uploader) }

  it 'processes a classification' do
    line = {"user_name"=>"    Scarymum", "user_id"=>"311503", "user_ip"=>"111", "workflow_id"=>"338", "workflow_name"=>"Survey", "workflow_version"=>"1890.18", "created_at"=>"2016-03-08 01:49:41 UTC", "gold_standard"=>nil, "expert"=>nil, "metadata"=>"{\"viewport\":{\"width\":1280,\"height\":657},\"started_at\":\"2016-03-08T01:45:03.169Z\",\"user_agent\":\"Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; .NET4.0E; .NET4.0C; .NET CLR 3.5.30729; .NET CLR 2.0.50727; .NET CLR 3.0.30729; Tablet PC 2.0; McAfee; GWX:DOWNLOADED; MDDCJS; rv:11.0) like Gecko\",\"utc_offset\":\"-39600\",\"finished_at\":\"2016-03-08T01:49:38.387Z\",\"live_project\":true,\"user_language\":\"en\",\"user_group_ids\":[]}", "annotations"=>"[{\"task\":\"survey\",\"value\":{\"choice\":\"NTHNGHR\",\"answers\":{},\"filters\":{}},\"task_label\":null}]", "subject_data"=>"{\"675752\":{\"retired\":null,\"ESId\":null,\"year\":\"2013\",\"month\":\"Oct\",\"camera\":\"D73\",\"season\":\"DryWet Oct-Dec\",\"DateUTC\":\"10/25/2013\",\"TimeUTC\":\"12:50:37 AM\",\"time_period\":\"Night 1736-0556\",\"Gorongosa_id\":\"21484_1000_D73_Season 1_Set 1_PICT4187\",\"distance_human\":\"533.9\",\"distance_water\":\"3786.25\",\"vegetation_edu\":\"Floodplain Grassland\"}}"}
    transformer.process(line)
    expect(transformer.output[0][:species]).to eq("Nothing here")

    transformer.finalize
    expect(carto_uploader).to have_received(:upload).once
  end
end
