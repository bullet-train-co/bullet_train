module Api::V1::ExceptionsHandler
  extend ActiveSupport::Concern

  included do
    helpers do
      def record_not_saved(model)
        handle_api_error(ActiveRecord::RecordNotSaved.new(model.errors.full_messages.first), :unprocessable_entity)
      end

      def handle_api_error(error, status = nil)
        error!("Something rather unexpected has occurred", 500) unless error

        error_class = error.class.name
        status_code = convert_status_symbol_to_integer(status) if status # allows an explicit status to be defined

        message = error.message # works fine for most errors
        message = "OAuth error: #{error}" if /WineBouncer::Errors/.match?(error_class)
        message = "Route error: #{error}" if /CanCan::AccessDenied/.match?(error_class)

        if /OAuthUnauthorizedError/.match?(error_class)
          error!(message, status_code || 401) # unauthorized
        elsif /OAuthForbiddenError/.match?(error_class) || /CanCan::AccessDenied/.match?(error_class)
          error!(message, status_code || 403) # forbidden
        elsif /RecordNotFound/.match?(error_class) || /unable to find/i.match?(message)
          error!(message, status_code || 404) # not found
        elsif /Grape::Exceptions::ValidationErrors/.match?(error_class)
          error!(message, status_code || 406) # not acceptable
        else
          Rails.logger.error message unless Rails.env.test?

          options = {error: message}
          options[:trace] = error.backtrace[0, 10] unless Rails.env.production?

          status_code = status_code || error.try(:status) || 500 # internal server error

          Rack::Response.new(options.to_json, status_code, {
            "Content-Type" => "application/json",
            "Access-Control-Allow-Origin" => "*",
            "Access-Control-Request-Method" => "*"
          }).finish
        end
      end

      def convert_status_symbol_to_integer(status)
        # defaults to an internal server error if the status code can't be found
        Rack::Utils::SYMBOL_TO_STATUS_CODE[status] || 500
      end
    end
  end
end
