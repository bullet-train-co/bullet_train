require "active_support/core_ext/integer/time"

Rails.application.configure do
  # 🚫 DEFAULT RAILS CONFIGURATION
  # This section represents the default settings for a Rails 6.0.0-rc1 application. Bullet Train's configuration and
  # your own should be specified at the end of the file, not in this section, even if the value you're configuring
  # has a default value here. This helps avoid merge conflicts in the future should the framework defaults change.

  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present? || ENV["RENDER"].present?

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Compress JavaScript
  config.assets.js_compressor = :terser

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  # config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "untitled_application_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # 🚫 DEFAULT BULLET TRAIN CONFIGURATION
  # This section represents the default settings for a Bullet Train application. Your own configuration should be
  # specified at the end of the file. Don't specify your application specific configuration in this section, even
  # if you want to change a default value specified here. Instead, simply re-specify the value in the section that
  # follows this section.

  config.force_ssl = true

  config.active_job.queue_adapter = :sidekiq

  if (ENV["AWS_ACCESS_KEY_ID"] || ENV["BUCKETEER_AWS_ACCESS_KEY_ID"]).present?
    config.active_storage.service = :amazon
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
