# DEFAULT RAILS GEMS
# This section is something close to the default Rails 5.2.3 Gemfile.
# Bullet Train updates the Ruby version. The comments in this section
# are from vanilla Rails.

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.1"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# BULLET TRAIN GEMS
# This section is all the gems we're adding.

group :test do
  gem "minitest-retry"
  gem "capybara-screenshot"
  gem "capybara-email"
  gem "shoulda-matchers"
  gem "rails-controller-testing"
  gem "minitest-matchers_vaccine"
  gem "database_cleaner"
  gem "mocha", "1.4.0"
  gem "magic_test"
end

# we use factories not just for testing, but also for generating example API payloads.
gem "factory_bot_rails"

# some development tools we actively use.
group :development do
  # letter opener opens any sent emails in your browser instead of having to setup an smtp trap.
  gem "letter_opener"

  # xray makes it easy to find which view or partial file an element is in when inspecting a page's source.
  gem "xray-rails"
end

# authentication.
gem "devise"
gem "omniauth"
gem "omniauth-stripe-connect"

# authorization.
gem "cancancan"

# api.
gem "active_model_serializers"

# administrative functionality.
gem "rails_admin"
gem "paper_trail"

# bootstrap and other ui stuff.
gem "bootstrap", "~> 4.3.1"
gem "font-awesome-rails"
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

# we'll occasionally use this for timestamps when accuracy isn't important.
gem "time_ago_in_words"

# enables `binding.pry` for debugging.
gem "pry"
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

# add color to some console output.
gem "colorize"

gem "nice_partials", github: "andrewculver/nice_partials", branch: "bt"

# turbo is in early development, so we're not waiting for releases.
gem "turbo-rails", github: "hotwired/turbo-rails", branch: "main"

# `standardrb --fix`
gem "standard"

group :production do
  # we suggest using postmark for email deliverability.
  gem "postmark-rails"

  # if you're hosting on heroku, this service is highly recommended for autoscaling of dynos.
  gem "rails_autoscale_agent"

  # exception tracking and uptime monitoring service with a generous free tier.
  gem "honeybadger"

  # another exception tracking service.
  gem "sentry-raven"

  # use s3 for active storage by default.
  gem "aws-sdk-s3", require: false
end

# YOUR GEMS
# you can add any gems you need below. by keeping them separate from
# our gems above, you avoid the likelihood that we'll have a merge
# conflict in the future.

# 🚅 super scaffolding will insert new oauth providers above this line.
