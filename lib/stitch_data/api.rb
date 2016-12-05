module StitchData
  class Api
    attr_accessor :upsert_fields, :data
    API_BASE_URL = "https://api.stitchdata.com/v2/import".freeze

    def initialize(upsert_fields, data)
      validate_required_upsert_fields(upsert_fields)
      @request_params = { Authorization: "Bearer #{StitchData.configuration.token}", content_type: 'application/json', accept: 'json' }
      @upsert_fields = upsert_fields
      @data = build_data(data)
    end

    def self.check_endpoint_status
      JSON.parse(RestClient.get("#{API_BASE_URL}/status"))["status"]
    end

    def upsert!
      RestClient.post( "#{API_BASE_URL}/push", @data.to_json, @request_params)
    end

    def validate!
      RestClient.post("#{API_BASE_URL}/validate", @data.to_json, @request_params)
    end

    private
    def build_data(data)
      data.map do |record|
        {
          client_id: StitchData.configuration.client_id,
          table_name: upsert_fields[:table_name].to_s,
          sequence: record[upsert_fields[:sequence]].to_i,
          action: "upsert",
          key_names: upsert_fields[:key_names].map(&:to_s),
          data: record
        }
      end
    end

    def validate_required_upsert_fields(upsert_fields)
      raise StitchData::Errors::WrongOrMissingUpsertFields, "Missing required upsert fields" if upsert_fields.keys.sort != [:sequence , :table_name , :key_names].sort
      raise StitchData::Errors::WrongOrMissingUpsertFields, "upsert field key_name should be of type Array" if upsert_fields[:key_names].class.name != "Array"
      upsert_fields
    end

  end
end
