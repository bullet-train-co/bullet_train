require_relative '../lib/bullet_train'
require_relative '../lib/colorizer'
require_relative '../lib/string/emoji'
require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BulletTrain
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # only enable this when generating api scaffold controllers.
    # config.api_only = true
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en

    # this actually doesn't appear to work.
    config.action_view.sanitized_allowed_protocols = ['http', 'bullettrain']
  end
end
