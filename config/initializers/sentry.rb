# frozen_string_literal: true

if ENV["SENTRY_DSN"]
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    sanitizer = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)

    config.before_send = lambda do |event, _hint|
      sanitizer.filter(event.to_hash)
    end
  end
end
