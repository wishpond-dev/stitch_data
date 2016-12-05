require 'spec_helper'

RSpec.shared_examples 'endpoint_validation' do
  before :each do
    allow(StitchData::Api).to receive(:check_endpoint_status).and_return({ status: "fail" })
  end

  it 'should raise error if StitchData endpoint is unavaialble' do
    expect { StitchData::Api.new(@shared_example_data[:upsert_fields], @shared_example_data[:data]).send( @shared_example_data[:method]) }.to raise_error(EndPointUnavailable)
  end
end
