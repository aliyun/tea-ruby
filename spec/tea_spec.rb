# frozen_string_literal: true

require 'rspec'

require 'tea_core'

describe 'Tea' do
  class MyModel < Tea::Model
    attr_accessor :request_id, :page_number, :page_size, :total_count
    def self.name_mapping
      {
        'request_id' => 'RequestId',
        'page_number' => 'PageNumber',
        'page_size' => 'PageSize',
        'total_count' => 'TotalCount'
      }
    end

    def self.type_mapping
      {
        'request_id' => 'string',
        'page_number' => 'string',
        'page_size' => 'string',
        'total_count' => 'string'
      }
    end
  end

  it 'model should ok' do
    model = MyModel.new(
      'RequestId' => 'request id'
    )
    expect(model.request_id).to eq('request id')
    hash = model.to_hash
    expect(hash).to eql(
      'RequestId' => 'request id',
      'PageNumber' => nil,
      'PageSize' => nil,
      'TotalCount' => nil
    )
  end

  class DescribeRegionsResponse < Tea::Model
    attr_accessor :request_id, :regions
    def self.name_mapping
      {
        'request_id' => 'RequestId',
        'regions' => 'Regions'
      }
    end

    def self.type_mapping
      {
        'request_id' => 'string',
        'regions' => DescribeRegionsResponseRegions
      }
    end
  end

  class DescribeRegionsResponseRegionsRegion < Tea::Model
    attr_accessor :region_id, :local_name, :region_endpoint, :status
    def self.name_mapping
      {
        'region_id' => 'RegionId',
        'local_name' => 'LocalName',
        'region_endpoint' => 'RegionEndpoint',
        'status' => 'Status'
      }
    end

    def self.type_mapping
      {
        'region_id' => 'string',
        'local_name' => 'string',
        'region_endpoint' => 'string',
        'status' => 'string'
      }
    end
  end

  class DescribeRegionsResponseRegions < Tea::Model
    attr_accessor :region
    def self.name_mapping
      {
        'region' => 'Region'
      }
    end

    def self.type_mapping
      {
        'region' => { 'type' => 'array', 'itemType' => DescribeRegionsResponseRegionsRegion }
      }
    end
  end

  it 'submodel should ok' do
    model = DescribeRegionsResponse.new(
      'RequestId' => '4CB944B5-94EC-42D1-82DE-80D206FA237D',
      'Regions' => {
        'Region' => [
          {
            'RegionId' => 'cn-qingdao',
            'RegionEndpoint' => 'ecs.aliyuncs.com',
            'LocalName' => '华北 1'
          }
        ]
      }
    )

    expect(model.regions.region).to be_an_instance_of(Array)
    expect(model.regions.region.length).to eq(1)
    region = model.regions.region[0]
    expect(region).to be_an_instance_of(DescribeRegionsResponseRegionsRegion)
    expect(region.region_id).to eq('cn-qingdao')
    expect(region.region_endpoint).to eq('ecs.aliyuncs.com')
    expect(region.local_name).to eq('华北 1')
  end
end
