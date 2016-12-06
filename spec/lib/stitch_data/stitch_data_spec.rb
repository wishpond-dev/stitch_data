require 'rspec'
require 'spec_helper'

RSpec.describe 'StitchData' do
  before :each do
    mocked_time = Time.new
    @first_record = { id: '1234', event_name: 'logged_in', created_at: mocked_time }
    @second_record = { id: '12345', event_name: 'logged_out', created_at: mocked_time }
    @data = [ @first_record, @second_record ]
    @sequence = :created_at
    @table_name = 'events'
    @key_names = [:id]
  end

  describe :initalize do

    it 'should validate upsert field key_name is of Array data type' do
       expect { StitchData::Api.new(@table_name, @sequence, :id, @data) }.to raise_error(StitchData::Errors::WrongUpsertFields)
    end

    it 'should validate upsert field sequence is a Fixnum' do
       expect { StitchData::Api.new(@table_name, "2", :id, @data) }.to raise_error(StitchData::Errors::WrongUpsertFields)
    end

    it 'should build valid data structue' do
      stitch_data = StitchData::Api.new(@table_name,@sequence, @key_names, @data)
      expect(stitch_data.data).to eq(
                                      [
                                        {
                                          client_id: StitchData.configuration.client_id,
                                          table_name: @table_name.to_s,
                                          sequence:  @first_record[@sequence].to_i,
                                          action: 'upsert',
                                          key_names:  @key_names.map(&:to_s),
                                          data: @first_record
                                        },
                                        {
                                          client_id: StitchData.configuration.client_id,
                                          table_name: @table_name.to_s,
                                          sequence: @second_record[@sequence].to_i,
                                          action: 'upsert',
                                          key_names: @key_names.map(&:to_s),
                                          data: @second_record
                                        }
                                      ]
                                    )
    end
  end
  describe :stitch_post_request do
    context :succesful_request do
      before :each do
        stub_request(:post, "https://api.stitchdata.com/v2/import/validate").to_return(status: 200, body: {status: "OK", message: "Valid"}.to_json)
      end

      it 'should return a symbolized hash with status and message' do
        expect(StitchData::Api.new(@table_name,@sequence, @key_names, @data).validate!).to eq({ "status" => "OK",
                                                                                                "message" => "Valid"
                                                                                              })
      end
    end
    context :failed_request do
      before :each do
        stub_request(:post, "https://api.stitchdata.com/v2/import/validate").to_return(status: 403, body: '{"status":"ERROR","errors":"An array of records is expected"}')
      end

      it 'should return symbolized hash with status and message' do
        expect(StitchData::Api.new(@table_name,@sequence, @key_names, @data).validate!).to eq({"status"=>"403 Forbidden", "message"=>"An array of records is expected"})
      end

    end

  end
end
