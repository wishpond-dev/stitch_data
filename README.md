A Ruby Wraper for Stitch Data API
===================




```rb
gem "stitch_data", "~> 1.0.0"
```

## Usage

You need a valid token  of token and

*Raises ArgumentError on bad arguments*

### Configuration
You can use an initializer for example if you're on Rails.
```rb
# initializers/noun_project_api.rb
StitchData.configure do |config|
  config.token = {your api token}
  config.client_id = { your client id }
end
```
### Usage
We reccomend to check the StitchData import api first.
https://docs.stitchdata.com/hc/en-us/articles/223734167-Import-API-Methods
Each request to Stitch must include the following keys
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
[Check us out!](https://www.tailorbrands.com)
