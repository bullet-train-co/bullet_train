require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{1.hour.to_i}" }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  # Disable caching for Action Mailer templates even if Action Controller
  # caching is enabled.
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Unlike controllers, the mailer instance doesn't have any context about the
  # incoming request so you'll need to provide the :host parameter yourself.
  config.action_mailer.default_url_options = { host: "www.example.com" }

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference missing actions.
  config.action_controller.raise_on_missing_callback_actions = true

  # 🚫 DEFAULT BULLET TRAIN CONFIGURATION
  # This section represents the default settings for a Bullet Train application. Your own configuration should be
  # specified at the end of the file. Don't specify your application specific configuration in this section, even
  # if you want to change a default value specified here. Instead, simply re-specify the value in the section that
  # follows this section.

  # TODO: Eventually we should enable this by default. Currently enabling it causes problems.
  # Related issue: https://github.com/bullet-train-co/bullet_train-core/issues/926
  # Once that issue has been resolved we should remove this comment block and the following config line.
  config.action_controller.raise_on_missing_callback_actions = false

  # We only enable this for a specific test.
  config.action_view.annotate_rendered_view_with_filenames = ENV["ENABLE_VIEW_ANNOTATION"] || false

  if ENV["SPRING"]
    # We don't use Spring by default, but we use it in `test/bin/setup-super-scaffolding-system-test`.
    config.cache_classes = false
    config.action_view.cache_template_loading = true
  else
    # Turn false under Spring and add config.action_view.cache_template_loading = true
    config.cache_classes = true
  end

  config.action_mailer.default_url_options = {host: "localhost", port: 3001}
  config.i18n.raise_on_missing_translations = true

  # TODO for some reason this doesn't seem to be doing anything.
  config.active_job.queue_adapter = :inline

  if defined?(Capybara::Lockstep)
    config.middleware.insert_before 0, Capybara::Lockstep::Middleware
  end

  # ✅ YOUR APPLICATION'S CONFIGURATION
  # If you need to customize your application's configuration, this is the place to do it. This helps avoid merge
  # conflicts in the future when Rails or Bullet Train update their own default settings.
end
