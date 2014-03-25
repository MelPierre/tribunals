require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module Tribunals
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: ENV['SMTP_DOMAIN'] }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # app title appears in the header bar
    config.app_title = 'Tribunal decisions'
    # phase governs text indicators and highlight colours
    # presumed values: alpha, beta, live
    config.phase = 'beta'
    # product type may also govern highlight colours
    # known values: information, service
    config.product_type = 'service'
    # govbranding switches on or off the crown logo, full footer and NTA font
    config.govbranding = true

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/scrapers)

    config.encoding = "utf-8"

    config.active_record.schema_format = :sql

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.assets.enabled = false
    config.assets.precompile += %w(
      gov-static/gov-goodbrowsers.css
      gov-static/gov-ie6.css
      gov-static/gov-ie7.css
      gov-static/gov-ie8.css
      gov-static/gov-fonts.css
      gov-static/gov-fonts-ie8.css
      gov-static/gov-print.css
      moj-base.css
      gov-static/gov-ie.js

      application-admin.js
    )
  end
end
