# README

## Updating the Kinesis-to-HTTP forwarder

``` bash
cd kinesis-to-http
pip install -r requirements.txt
lambda-uploader
```

## Development setup

Go to https://panoptes-staging.zooniverse.org/oauth/applications and create an application. Paste the credentials into a
new file called `.env` like so:

``` bash
ZOONIVERSE_OAUTH_KEY=key
ZOONIVERSE_OAUTH_SECRET=secret
```

## Test setup

Use docker-compose to start a bash shell

To start the containers run

+ `docker-compose run --service-ports --rm -e RAILS_ENV=test education bash`

Now from within the container

+ First time you will need to create the database
  + `bundle exec rake db:create`

+ Run the tests with
  + `bundle exec rspec`
  + `bundle exec rspec path/to/test_file.rb`
