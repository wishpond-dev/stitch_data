# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start


require "bundler/setup"
require "pry"
require 'json'
require './lib/stitch_data/api'
require './lib/stitch_data'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = "documentation"
  config.color = true
end
