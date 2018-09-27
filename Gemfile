source 'https://rubygems.org'

gem 'rails'

# Ruby interface to the PostgreSQL
gem 'pg'

# server for applications
gem 'puma'

# JSON serialization of objects
gem 'active_model_serializers'

# makes passwords secure
gem 'bcrypt'

# ruby implementation of JWT standard
gem 'jwt'

# providing objects with Pub/Sub capabilities
gem 'homie'

# implement authorization logic
gem 'pundit'

# client library for Redis
gem 'redis'

group :development, :test do
  # implements BDD for Ruby
  gem 'rspec-rails'

  # testing matchers
  gem 'shoulda-matchers'

  # provides the its method to specify the expected value of an attribute
  gem 'rspec-its'

  # a library for generating fake data
  gem 'faker'

  # generates data for objects
  gem 'factory_bot_rails'

  # code coverage for Ruby
  gem 'simplecov', require: false

  # debugger
  gem 'pry-byebug'
end

group :test do
  # cleans databases for testing
  gem 'database_cleaner'
end
