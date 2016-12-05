# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stitch_data/version'

Gem::Specification.new do |s|
  s.name        = 'stitch_data'
  s.version     = StitchData::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = Date.today.to_s
  s.summary     = "Ruby wraper for the Stitch Data Api"
  s.description = "wraper for the upsert method used for import data into stitch"
  s.authors     = ['Omri Shuva']
  s.email       = 'omri@tailorbrands.com'
  s.homepage    = 'https://github.com/TailorBrands/stitch_data'
  s.files       = Dir['README.rdoc', 'VERSION', 'MIT-LICENSE', 'Rakefile', 'lib/**/*']
  s.test_files  = Dir['spec/**/*']

  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0'

  s.add_dependency 'json', '~> 1.8.0'
  s.add_dependency 'rest-client', '~> 1.8.0'
end
