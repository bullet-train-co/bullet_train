require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  # config.cache_store = :mem_cache_store

  # Replace the default in-process and non-durable queuing backend for Active Job.
  # config.active_job.queue_adapter = :resque

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = { host: "example.com" }

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # 🚫 DEFAULT BULLET TRAIN CONFIGURATION
  # This section represents the default settings for a Bullet Train application. Your own configuration should be
  # specified at the end of the file. Don't specify your application specific configuration in this section, even
  # if you want to change a default value specified here. Instead, simply re-specify the value in the section that
  # follows this section.

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present? || ENV["RENDER"].present?

  config.active_job.queue_adapter = :sidekiq

  if (ENV["AWS_ACCESS_KEY_ID"] || ENV["BUCKETEER_AWS_ACCESS_KEY_ID"]).present?
    config.active_storage.service = :amazon
  elsif ENV["CLOUDINARY_URL"].present?
    config.active_storage.service = :cloudinary
  else
    puts "WARNING! : We didn't find an active_storage.service configured so we're falling back to the local store, but it's A VERY BAD IDEA to rely on it in production unless you know what you're doing."
    config.active_storage.service = :local
  end

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # generate full urls using the base url configuration setting.
  unless default_url_options_from_base_url.empty?
    Rails.application.routes.default_url_options = default_url_options_from_base_url
    config.action_mailer.default_url_options = default_url_options_from_base_url
  end

  # if you want to use some other smtp configuration, please don't
  # modify this configuration, as it will cause merge conflicts
  # in the future if we update this built-in configuration.
  # instead, you should add yours after the comment toward the
  # end of this file. 🚫 ✌️

  if ENV["POSTMARK_API_TOKEN"].present?
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = {
      api_token: ENV["POSTMARK_API_TOKEN"]
    }

  elsif ENV["MAILGUN_SMTP_SERVER"].present?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_options = {from: "noreply@#{ENV["MAILGUN_DOMAIN"]}"}
    config.action_mailer.smtp_settings = {
      # double warning: please don't modify this configuration.
      # if you want to provide your own smtp configuration,
      # please add it after the comment at the end of this file.
      address: ENV["MAILGUN_SMTP_SERVER"],
      port: ENV["MAILGUN_SMTP_PORT"],
      domain: ENV["MAILGUN_DOMAIN"],
      user_name: ENV["MAILGUN_SMTP_LOGIN"],
      password: ENV["MAILGUN_SMTP_PASSWORD"],
      authentication: "plain",
      enable_starttls_auto: true
    }

    if inbound_email_enabled?
      # use the same mail provider for inbound mail as we're using for outbound mail.
      config.action_mailbox.ingress = :mailgun
    end
  end

  # This header namespace will be used when sending webhook events.
  config.outgoing_webhooks[:webhook_headers_namespace] = "X-Webhook-Untitled-Application"

  # Automatic endpoint deactivation for outgoing webhooks. This feature is disabled by default.
  # If you want to enable it, set the following configuration option to true.
  # config.outgoing_webhooks[:automatic_endpoint_deactivation_enabled] = true

  # Uncomment the following lines to change the default settings for automatic endpoint deactivation.
  # config.outgoing_webhooks[:automatic_endpoint_deactivation_settings] = {
  #   max_limit: 50,
  #   deactivation_in: 3.days
  # }

  # ✅ YOUR APPLICATION'S CONFIGURATION
  # If you need to customize your application's configuration, this is the place to do it. This helps avoid merge
  # conflicts in the future when Rails or Bullet Train update their own default settings.
end
