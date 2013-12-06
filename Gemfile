source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'
source 'http://gems.dsd.io'

gem 'nokogiri'

gem 'rails'

gem 'pg'
gem 'carrierwave', :git => 'https://github.com/carrierwaveuploader/carrierwave.git', :branch => 'master'
gem 'will_paginate', '~> 3.0'
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
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'whenever', :require => false
gem 'haml-rails'
gem 'html2haml'
gem 'jquery-rails'
gem 'friendly_id', github: 'FriendlyId/friendly_id', branch: 'master'
gem 'appsignal'

# frontend gems
gem 'govuk_frontend_toolkit'
gem 'moj_frontend_toolkit_gem', git: 'https://github.com/ministryofjustice/moj_frontend_toolkit_gem.git', tag: 'v0.1.0'
