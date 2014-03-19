source 'https://rubygems.org'
source 'http://gems.dsd.io' unless ENV['TRAVIS'] || ENV['HEROKU']

gem 'nokogiri'

gem 'rails', '4.0.3'

gem 'pg'
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave', branch: 'master'
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Authentication
gem 'devise'
gem 'devise_invitable'

# Forms
gem 'simple_form'

# For speeding up Postgres array parsing
gem 'pg_array_parser'

group :test, :development do
  gem 'rspec-rails'
  gem 'byebug'
  gem 'database_cleaner'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'guard-rspec'
  gem 'guard'
  gem 'guard-livereload'
  gem 'hirb'
  gem 'wirble'
  gem 'wirb'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'headless'
  gem 'timecop'
end

group :test do
  gem 'rake'
end

group :assets do
  gem 'sass-rails'
end

gem 'unicorn'
gem 'fog'
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
