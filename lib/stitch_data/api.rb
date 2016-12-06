module StitchData
  class Api
    attr_accessor :table_name, :sequence, :key_names, :data
    API_BASE_URL = "https://api.stitchdata.com/v2/import".freeze
    DEFAULT_API_ACTION = "upsert".freeze
    DEFAULT_REQUEST_PARAMS = {content_type: 'application/json', accept: 'json'}.freeze

    def initialize(table_name, sequence, key_names, data)
      validate_key_names_is_array(key_names)
      @request_params = { Authorization: "Bearer #{StitchData.configuration.token}" }.merge(DEFAULT_REQUEST_PARAMS)
      @table_name = table_name.to_s
      @sequence = sequence.to_sym
      @key_names = key_names.map(&:to_s)
      @data = build_records(data)
    end

    def upsert!
      stitch_post_request("#{API_BASE_URL}/push")
    end

    def validate!
      stitch_post_request("#{API_BASE_URL}/validate")
    end

    private

    def build_records(records)
      records.map do |record|
        {
          client_id: StitchData.configuration.client_id,
          table_name: table_name,
          sequence: record[sequence].to_i,
          action: DEFAULT_API_ACTION,
          key_names: key_names,
          data: record
        }
      end
    end

    def validate_key_names_is_array(key_names)
      raise StitchData::Errors::WrongUpsertFields, "key_names field must be an Array" unless key_names.is_a?(Array)
    end

    def stitch_post_request(url)
      JSON.parse(RestClient.post(url, @data.to_json, @request_params))
    rescue RestClient::ExceptionWithResponse => e
      { "status" => e.message, "message" => JSON.parse(e.response)["errors"] }
    end
  end
end
