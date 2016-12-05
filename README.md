A Ruby Wraper for Stitch Data API
===================


Stitch Data is an ETL service built for developers, it supports many built in third party integrations.
In case you need to integrate a data source which is not supported by Stitch you can use the API that utilizes their data replication engine.

### Prerequisite
- Create StitchData Account <br/>
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
```rb
stitch_upsert_keys = { sequence: :created_at, table_name: :some_table_name, key_names: [:id] }
```
Send data to stitch like the following
```rb
StitchData::Api.new(stitch_upsert_keys, data).upsert!
```

###Integration Testing
Use the validate! method in order to check if Stitch accepts the data your data.
```rb
StitchData::Api.new(stitch_upsert_keys, data).validate!
```

## Disclaimer

This is completely unofficial and is not related to StitchData company in any way.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## About Tailor Brands
[Check us out!](https://goo.gl/h26ZwU)
