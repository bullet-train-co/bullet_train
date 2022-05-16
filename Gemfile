# DEFAULT RAILS GEMS
# This section is something close to the default Rails Gemfile.
# Bullet Train updates the Ruby version. The comments in this section
# are from vanilla Rails.

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

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
gem "redis", "~> 4.0"

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

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", github: "teamcapybara/capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# BULLET TRAIN GEMS
# This section is the list of Ruby gems included by default for Bullet Train.

# TODO We have to reference `devise` in the local application Gemfile before `bullet_train`, otherwise our overrides of
# its views don't take effect. Is there another way around this?
gem "devise"

# Core packages.
gem "bullet_train"
gem "bullet_train-super_scaffolding"
gem "bullet_train-api"
gem "bullet_train-outgoing_webhooks"
gem "bullet_train-incoming_webhooks"
gem "bullet_train-themes-light"
gem "bullet_train-integrations"
gem "bullet_train-integrations-stripe"

# Optional support packages.
gem "bullet_train-sortable"
gem "bullet_train-scope_questions"
gem "bullet_train-obfuscates_id"

# source "https://BULLET_TRAIN_PRO_TOKEN@gem.fury.io/bullettrain" do
#   gem "bullet_train-action_models"
#   gem "bullet_train-conversations"
#   gem "bullet_train-audit_logs"
# end

group :development do
  # Open any sent emails in your browser instead of having to setup an SMTP trap.
  gem "letter_opener"

  # Ruby formatter. Try `standardrb --fix`.
  gem "standard"

  # Similar to standard for correcting format.
  gem "rails_best_practices"

  # Rails doesn't include this by default, but we depend on it.
  gem "foreman"
end

group :test do
  # Helps smooth over flakiness in system tests.
  gem "minitest-retry"

  # Interact with emails during testing.
  gem "capybara-email"

  # Generate test objects.
  gem "factory_bot_rails", group: :development

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
end

# TODO Have to specify this dependency here until our changes are in the original package.
gem "active_hash", github: "bullet-train-co/active_hash"

# TODO Have to specify this dependency here until our changes are in the original package or properly forked.
gem "wine_bouncer", github: "bullet-train-co/wine_bouncer"

# # TODO Have to specify this dependency here until a fix is in the original package.
# gem "xray-rails", github: "brentd/xray-rails", ref: "4f6cca0"

# YOUR GEMS
# You can add any Ruby gems you need below. By keeping them separate from our gems above, you'll avoid the likelihood
# that you run into a merge conflict in the future.

# 🚅 super scaffolding will insert new oauth providers above this line.
