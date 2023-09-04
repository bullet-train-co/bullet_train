# DEFAULT RAILS GEMS
# This section is something close to the default Rails Gemfile.
# Bullet Train updates the Ruby version. The comments in this section
# are from vanilla Rails.

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby(File.read(File.expand_path(".ruby-version", __dir__)))

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.0"

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

# Core packages.
gem "bullet_train"
gem "bullet_train-super_scaffolding"
gem "bullet_train-api"
gem "bullet_train-outgoing_webhooks"
gem "bullet_train-incoming_webhooks"
gem "bullet_train-themes"
gem "bullet_train-themes-light"
gem "bullet_train-integrations"
gem "bullet_train-integrations-stripe"

# Optional support packages.
gem "bullet_train-sortable"
gem "bullet_train-scope_questions"
gem "bullet_train-obfuscates_id"
