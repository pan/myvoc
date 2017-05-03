require_relative 'boot'

# Pick the frameworks you want:
# require 'rails/all'
require 'active_model/railtie'
# require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'action_cable/engine'
require 'active_job/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myvoc
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
