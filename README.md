A Ruby Wraper for Stitch Data API
===================
(https://codeclimate.com/repos/584577393f11b34826000001/badges/aebfc4d9aa9cf0b17c72/gpa.svg)](https://codeclimate.com/repos/584577393f11b34826000001/feed)

Stitch Data is an ETL service built for developers, it supports many built in third party integrations.
In case you need to integrate a data source which is not supported by Stitch you can use the API that utilizes their data replication engine.

### Prerequisite
- Create Stitch Data Account <br/>
- Connect the account to your favorite data stores ( Redshift, BigQuery, PostgreSQL ) <br/>
- Create an import API integration in the Stitch Console and generate your API token.

### include the gem
Rails
```rb
gem "stitch_data", "~> 1.0.0"
```
Sinatra
```rb
gem install "stitch_data", "~> 1.0.0"
require 'stitch_data'
```

### Configuration
You can use an initializer for example if you're on Rails.
```rb
# initializers/stitch_data_api.rb
StitchData.configure do |config|
  config.token = "your-api-token"
  config.client_id = "your-client-id"
end
```
### Usage
We reccomend to read the [Stitch import api documetation](https://docs.stitchdata.com/hc/en-us/articles/223734167-Import-API-Methods ) in order to understand how to utilize the upsert method for your data replication needs. <br/>
<br/>
Each upsert request to Stitch must include the following keys
table_name -> name of the destination table <br/>
sequence -> record sequence number (Integer/Timestamp) <br/>
key_names -> table primary keys (Array)
<br/>
Send data to stitch like the following
```rb
StitchData::Api.new(table_name, sequence, key_names, data).upsert!
```

###Integration Testing
Use the validate! method in order to validate your upsert requests goes through
```rb
StitchData::Api.new(table_name, sequence, key_names, data).validate!
```

## Disclaimer

This is completely unofficial and is not related to Stitch Data company in any way.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## About Tailor Brands
[Check us out!](https://www.tailorbrands.com)
