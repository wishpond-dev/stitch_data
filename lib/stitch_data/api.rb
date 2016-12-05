module StitchData
  class Api
    attr_accessor :upsert_fields, :insert_bulk_size, :data
    API_BASE_URL = "https://api.stitchdata.com/v2/import".freeze

    def initialize(upsert_fields, data)
      @request_params = { Authorization: "Bearer #{StitchData.configuration.token}", content_type: 'application/json', accept: 'json' }
      @upsert_fields = validate_required_upsert_fields(upsert_fields)
      @data = build_data(data)
    end

    def self.check_endpoint_status
      JSON.parse(RestClient.get("#{API_BASE_URL}/status"))["status"]
    end

    def upsert!
      validate_endpoint_status!
      RestClient.post(upsert_url, @data.to_json, @request_params)
    end

    def validate!
      validate_endpoint_status!
      RestClient.post(validate_url, @data.to_json, @request_params)
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

    def validate_endpoint_status!
      raise EndPointUnavailable, "StitchData endpoint is currently unavailable" unless self.class.check_endpoint_status == "OK"
    end

    def upsert_url
      "#{API_BASE_URL}/push"
    end

    def validate_url
      "#{API_BASE_URL}/validate"
    end

    def validate_required_upsert_fields(upsert_fields)
      raise WrongOrMissingUpsertFields, "Missing required upsert fields" if upsert_fields.keys.sort != [:sequence , :table_name , :key_names].sort
      raise  WrongOrMissingUpsertFields, "upsert field key_name should be of type Array" if upsert_fields[:key_names].class.name != "Array"
      upsert_fields
    end

  end
end

class EndPointUnavailable < StandardError
end

class WrongOrMissingUpsertFields < StandardError
end
