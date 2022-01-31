# DEFAULT RAILS GEMS
# This section is something close to the default Rails 5.2.3 Gemfile.
# Bullet Train updates the Ruby version. The comments in this section
# are from vanilla Rails.

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.0"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

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

# Use Sass to process CSS
# gem "sassc-rails"

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
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

# BULLET TRAIN GEMS
# This section is all the gems we're adding.

group :development, :test do
  # Increase parallelism to run CircleCI tests across multiple nodes
  gem "knapsack_pro"

  # `standardrb --fix`
  gem "standard"

  # Similar to standard for correcting format
  gem "rails_best_practices"

  # for super scaffolding: "select *a* team member" vs. "select *an* option".
  gem "indefinite_article"
end

group :test do
  gem "timecop"
  gem "minitest-retry"
  gem "capybara-screenshot"
  gem "capybara-email"
  gem "magic_test"
end

# some development tools we actively use.
group :development do
  # letter opener opens any sent emails in your browser instead of having to setup an smtp trap.
  gem "letter_opener"

  # xray makes it easy to find which view or partial file an element is in when inspecting a page's source.
  gem "xray-rails"

  # add color to some console output.
  gem "colorize"
end

# Use SCSS for stylesheets
# TODO I think we can remove this? Isn't this for asset pipeline?
gem "sass-rails", ">= 6"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"

# Enables use of I18n in JavaScript for locales
gem "i18n-js"

# we use factories not just for testing, but also for generating example API payloads.
gem "factory_bot_rails"

# authentication.
gem "devise", github: "heartcombo/devise"
gem "doorkeeper"
gem "omniauth"
gem "omniauth-stripe-connect"
# TODO Remove when we're able to properly upgrade Omniauth.
# https://github.com/omniauth/omniauth/wiki/Resolving-CVE-2015-9284
gem "omniauth-rails_csrf_protection"
# TODO This doesn't work on Rails 7 yet. Get this working again.
# gem "devise-two-factor"
gem "rqrcode"

# authorization.
gem "cancancan"

# TODO This _has_ to be specified in the local application's Gemfile because the `bullet_train-api` gemspec can't
# specify a specific `github` value. We need to get whatever changes we've made here into the original package, or
# fork it properly.
gem "wine_bouncer", github: "bullet-train-co/wine_bouncer"

# administrative functionality.
gem "paper_trail"

# ui stuff.
gem "trix", github: "bullet-train-co/trix"

# subscriptions and/or oauth examples.
gem "stripe"

# allow users to supply content with markdown formatting.
# powers our markdown() view helper.
gem "commonmarker"

# we use this to detect the size of the logo assets.
gem "fastimage"

# we use this to add "'s" as appropriate in certain headings.
gem "possessive"

# background jobs.
gem "sidekiq"

# cloud file hosting, image resizing, and cdn.
gem "cloudinary"

# enables `binding.pry` for debugging.
gem "pry"
gem "pry-stack_explorer"
gem "awesome_print"

# define ENV values in `config/application.yml`.
gem "figaro"

# inline all css for emails.
gem "premailer-rails"

# parse natural language dates.
gem "chronic"

# parse and format phone numbers.
gem "phonelib"

# validate email addresses.
gem "valid_email"

# extract the body from emails received using action inbox.
gem "extended_email_reply_parser"

gem "nice_partials", "~> 0.1"
gem "storybook_rails", "~> 1.0"

# for obfuscating ids in urls
gem "hashids"

# Add helpful scopes automatically on booleans and date/time attributes.
gem "microscope"

# serving language based on browser settings
gem "http_accept_language"

gem "cable_ready", "5.0.0.pre8"
gem "hiredis"

# TODO We have to specify this in the local application until our improvements are merged into the official
# `active_hash` package. At that point, we can just depend on the `bullet_train` package to pull this in.
gem "active_hash", github: "bullet-train-co/active_hash"

gem "bullet_train"
gem "bullet_train-api"
gem "bullet_train-serializers"
gem "bullet_train-super_scaffolding"
gem "bullet_train-incoming_webhooks"
gem "bullet_train-roles"
gem "bullet_train-scope_validator"
gem "bullet_train-outgoing_webhooks-core"
gem "bullet_train-outgoing_webhooks"
gem "bullet_train-outgoing_webhooks-serializers"
gem "bullet_train-outgoing_webhooks-api"
gem "bullet_train-integrations-stripe"
gem "bullet_train-super_scaffolding-templates"
gem "bullet_train-themes"
gem "bullet_train-themes-base"
gem "bullet_train-themes-tailwind_css"
gem "bullet_train-themes-light"

group :production do
  # we suggest using postmark for email deliverability.
  gem "postmark-rails"

  # if you're hosting on heroku, this service is highly recommended for autoscaling of dynos.
  gem "rails_autoscale_agent"

  # exception tracking and uptime monitoring service with a generous free tier.
  gem "honeybadger"

  # another exception tracking service
  gem "sentry-ruby"
  gem "sentry-rails"
  gem "sentry-sidekiq"

  # use s3 for active storage by default.
  gem "aws-sdk-s3", require: false
end

# YOUR GEMS
# you can add any gems you need below. by keeping them separate from
# our gems above, you avoid the likelihood that we'll have a merge
# conflict in the future.

# 🚅 super scaffolding will insert new oauth providers above this line.
