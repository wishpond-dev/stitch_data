require 'rspec'
require 'spec_helper'
RSpec.describe 'StitchData' do
  before :each do
    mocked_time = Time.new
    @first_record = { id: '1234', event_name: 'logged_in', created_at: mocked_time }
    @second_record = { id: '12345', event_name: 'logged_out', created_at: mocked_time }
    @data = [ @first_record, @second_record ]
    @upsert_fields = { sequence: :created_at, table_name: 'events', key_names: [:id] }
  end

  describe :initalize do

    it 'should raise error unless required upsert fields where given' do
      expect { StitchData::Api.new({},@data) }.to raise_error(WrongOrMissingUpsertFields)
    end

    it 'should validate upsert field key_name is of Array data type' do
       @upsert_fields[:key_names] = :id
       expect { StitchData::Api.new(@upsert_fields,@data) }.to raise_error(WrongOrMissingUpsertFields)
    end

    it 'should build valid data structue' do
      stitch_data = StitchData::Api.new(@upsert_fields, @data)
      expect(stitch_data.data).to eq(
                                      [
                                        {
                                          client_id: StitchData.configuration.client_id,
                                          table_name: @upsert_fields[:table_name].to_s,
                                          sequence:  @first_record[@upsert_fields[:sequence]].to_i,
                                          action: 'upsert',
                                          key_names:  @upsert_fields[:key_names].map(&:to_s),
                                          data: @first_record
                                        },
                                        {
                                          client_id: StitchData.configuration.client_id,
                                          table_name: @upsert_fields[:table_name].to_s,
                                          sequence: @second_record[@upsert_fields[:sequence]].to_i,
                                          action: 'upsert',
                                          key_names: @upsert_fields[:key_names].map(&:to_s),
                                          data: @second_record
                                        }
                                      ]
                                    )
    end
  end

  context :api_methods do

    before :each do
      @shared_example_data = { upsert_fields: @upsert_fields, data: @data, method: 'validate!' }
    end

    describe :upsert! do
      it_behaves_like('endpoint_validation', @shared_example_data)
    end

    describe :validate! do
      it_behaves_like('endpoint_validation', @shared_example_data)
    end
  end
end
