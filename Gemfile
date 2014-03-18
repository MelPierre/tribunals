source 'https://rubygems.org'
source 'http://gems.dsd.io'

gem 'nokogiri'

gem 'rails', '4.0.3'

gem 'pg'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave', branch: 'master'
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# For speeding up Postgres array parsing
gem 'pg_array_parser'

group :test, :development do
  gem 'rspec-rails'
  gem 'warden-rspec-rails'
  gem 'byebug'
  gem 'database_cleaner'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'hirb'
  gem 'wirble'
  gem 'wirb'
end

group :test do
  gem 'rake'
end

group :assets do
  gem 'sass-rails'
end

gem 'unicorn'
gem 'fog'
gem 'rails_warden'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'whenever', require: false
gem 'haml-rails'
gem 'html2haml'
gem 'jquery-rails'
gem 'friendly_id', github: 'FriendlyId/friendly_id', branch: 'master'
gem 'appsignal'

# frontend gems
gem 'govuk_frontend_toolkit', github: 'alphagov/govuk_frontend_toolkit_gem', submodules: true
gem 'moj_frontend_toolkit_gem', github: 'ministryofjustice/moj_frontend_toolkit_gem', tag: 'v0.2.1'
