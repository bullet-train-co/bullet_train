require_relative "boot"

require "rails/all"
require "pry"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative "../lib/bullet_train"

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

    config.to_prepare do
      # TODO Is there a way to move this into `bullet_train-api`?
      Doorkeeper::ApplicationController.layout "devise"

      # TODO Is there a better way to implement this?
      # This monkey patch is required to ensure the OAuth2 token includes which team was connected to.
      if Doorkeeper::TokensController
        class Doorkeeper::TokensController
          def create
            headers.merge!(authorize_response.headers)

            user = if authorize_response.is_a?(Doorkeeper::OAuth::ErrorResponse)
              nil
            else
              User.find(authorize_response.token.resource_owner_id)
            end

            # Add the selected `team_id` to this response.
            render json: authorize_response.body.merge(user&.teams&.one? ? {"team_id" => user.team_ids.first} : {}),
              status: authorize_response.status
          rescue Doorkeeper::Errors::DoorkeeperError => e
            handle_token_exception(e)
          end
        end
      end
    end
  end
end
