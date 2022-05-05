require_relative "boot"
require_relative "../lib/bullet_train"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UntitledApplication
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # See `config/locales/locales.yml` for a list of available locales.
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = YAML.safe_load(File.read("config/locales/locales.yml"), aliases: true).with_indifferent_access.dig(:locales).keys.map(&:to_sym)
    config.i18n.default_locale = config.i18n.available_locales.first
  end
end
