require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  # config.public_file_server.enabled = false

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "untitled_application_production"

  # Disable caching for Action Mailer templates even if Action Controller
  # caching is enabled.
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # 🚫 DEFAULT BULLET TRAIN CONFIGURATION
  # This section represents the default settings for a Bullet Train application. Your own configuration should be
  # specified at the end of the file. Don't specify your application specific configuration in this section, even
  # if you want to change a default value specified here. Instead, simply re-specify the value in the section that
  # follows this section.

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present? || ENV["RENDER"].present?

  # Compress JavaScript
  config.assets.js_compressor = :terser

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

  # ✅ YOUR APPLICATION'S CONFIGURATION
  # If you need to customize your application's configuration, this is the place to do it. This helps avoid merge
  # conflicts in the future when Rails or Bullet Train update their own default settings.
end
