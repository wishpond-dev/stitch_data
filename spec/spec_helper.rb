# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start


require "bundler/setup"
require "pry"
require 'json'
require 'webmock/rspec'
require './lib/stitch_data/api'
require './lib/stitch_data'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.formatter = "documentation"
  config.color = true
end

require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end

SimpleCov.start
