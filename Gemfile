# DEFAULT RAILS GEMS
# This section is something close to the default Rails Gemfile.
# Bullet Train updates the Ruby version. The comments in this section
# are from vanilla Rails.

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby(File.read(File.expand_path(".ruby-version", __dir__)))

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.0.5"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# A natural language date/time parser.
gem "chronic"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  # A gem for generating test coverage results in your browser.
  gem "simplecov", require: false

  # Generate test objects.
  # 6.3.0 and 6.4.0 have a bug https://github.com/thoughtbot/factory_bot_rails/issues/433
  # And now 6.4.1 and 6.4.2 break some things: https://github.com/bullet-train-co/bullet_train-core/issues/707
  gem "factory_bot_rails", "~> 6.2", "!= 6.3.0", "!= 6.4.0", "!= 6.4.1", "!= 6.4.2"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Workaround to get image process to behave on a Mac in development
  # https://github.com/libvips/ruby-vips/issues/155#issuecomment-1047370993
  gem "ruby-vips"

  # Generate a diagram of all the models in the app by running:
  # bundle exec erd
  gem "rails-erd"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "~> 3.39"

  # Selenium is the default default Capybara driver for system tests that ships with
  # Rails. Cuprite is an alternative driver that uses Chrome's native DevTools protocol
  # and offers improved speed and reliability, but only works with Chrome. If you want
  # to switch to Cuprite, you can comment out the `selenium-webdriver` gem
  # and uncomment the `cuprite` gem below. Bullet Train will automatically load
  # the correct configuration based on which gem is included.
  gem "selenium-webdriver"

  # gem "cuprite"
end

# BULLET TRAIN GEMS
# This section is the list of Ruby gems included by default for Bullet Train.

# We use a constant here so that we can ensure that all of the bullet_train-*
# packages are on the same version.
BULLET_TRAIN_VERSION = "1.6.28"

# Core packages.
gem "bullet_train", BULLET_TRAIN_VERSION
gem "bullet_train-super_scaffolding", BULLET_TRAIN_VERSION
gem "bullet_train-api", BULLET_TRAIN_VERSION
gem "bullet_train-outgoing_webhooks", BULLET_TRAIN_VERSION
gem "bullet_train-incoming_webhooks", BULLET_TRAIN_VERSION
gem "bullet_train-themes", BULLET_TRAIN_VERSION
gem "bullet_train-themes-light", BULLET_TRAIN_VERSION
gem "bullet_train-integrations", BULLET_TRAIN_VERSION
gem "bullet_train-integrations-stripe", BULLET_TRAIN_VERSION

# Optional support packages.
gem "bullet_train-sortable", BULLET_TRAIN_VERSION
gem "bullet_train-scope_questions", BULLET_TRAIN_VERSION
gem "bullet_train-obfuscates_id", BULLET_TRAIN_VERSION

# Core gems that are dependencies of gems listed above. Technically they
# shouldn't need to be listed here, but we list them so that we can keep
# version numbers in sync.
gem "bullet_train-fields", BULLET_TRAIN_VERSION
gem "bullet_train-has_uuid", BULLET_TRAIN_VERSION
gem "bullet_train-roles", BULLET_TRAIN_VERSION
gem "bullet_train-scope_validator", BULLET_TRAIN_VERSION
gem "bullet_train-super_load_and_authorize_resource", BULLET_TRAIN_VERSION
gem "bullet_train-themes-tailwind_css", BULLET_TRAIN_VERSION

gem "devise"
gem "devise-two-factor"
gem "rqrcode"

# Admin panel
gem "avo", ">= 3.1.7"

group :development do
  # Open any sent emails in your browser instead of having to setup an SMTP trap.
  gem "letter_opener"

  # Ruby formatter. Try `standardrb --fix`.
  gem "standard"

  # Similar to standard for correcting format.
  gem "rails_best_practices"

  # Rails doesn't include this by default, but we depend on it.
  gem "foreman"

  # For colorizing text in command line scripts.
  gem "colorize"
end

group :test do
  # Helps smooth over flakiness in system tests.
  gem "minitest-retry"

  # Better test output
  gem "minitest-reporters"

  # Interact with emails during testing.
  gem "capybara-email"

  # Write system tests by pointing and clicking in your browser.
  gem "magic_test"

  # Increase parallelism to run CircleCI tests across multiple nodes
  gem "knapsack_pro"
end

group :production do
  # We suggest using Postmark for email deliverability.
  gem "postmark-rails"

  # If you're hosting on Heroku, this service is highly recommended for autoscaling of dynos.
  gem "rails_autoscale_agent"

  # Exception tracking, uptime monitoring, and status page service with a generous free tier.
  gem "honeybadger"

  # Another exception tracking service.
  gem "sentry-ruby"
  gem "sentry-rails"
  gem "sentry-sidekiq"

  # Use S3 for Active Storage by default.
  gem "aws-sdk-s3", require: false

  gem "terser"
end

# Use Ruby hashes as readonly datasources for ActiveRecord-like models.
gem "active_hash"

# A great debugger.
gem "pry"

# YOUR GEMS
# You can add any Ruby gems you need below. By keeping them separate from our gems above, you'll avoid the likelihood
# that you run into a merge conflict in the future.

# 🚅 super scaffolding will insert new oauth providers above this line.
