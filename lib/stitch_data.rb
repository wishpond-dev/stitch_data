require 'json'
require 'rest-client'
require 'stitch_data/api'

module StitchData
  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end

  # Main configuration class.
  class Configuration
    attr_accessor :token, :client_id

    def initialize
      @token = nil
      @client_id = nil
    end
  end
end
