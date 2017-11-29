source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end



gem 'rails'
gem 'pg'
gem 'puma'
gem 'active_model_serializers'

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'rspec-its'
  gem 'faker'
  gem 'factory_girl_rails'
end

group :development do
  gem 'byebug', platform: :mri
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
