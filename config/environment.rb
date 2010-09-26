# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/jobs )

  # GEM CONFIGURATION IS DONE WITH BUNDLER. DO NOT USE CONFIG.GEM!
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # We don't need ActiveResource
  config.frameworks -= [ :active_resource ]
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  config.time_zone = 'UTC' # EVE Time

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

require 'reve'