ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/email'
require 'support/waiting'
require 'minitest/spec'
require 'active_support/testing/assertions'
require 'minitest/retry'
require File.expand_path('../../lib/bullet_train', __FILE__)

Minitest::Retry.use!(retry_count: 3, verbose: true, exceptions_to_retry: [Net::ReadTimeout])

OmniAuth.config.test_mode = true

Capybara.default_max_wait_time = 15
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.default_driver = :selenium_chrome_headless

Capybara.register_server :puma do |app, port, host|
  require 'rack/handler/puma'
  # current we need at least three threads for the webhooks tests to pass.
  Rack::Handler::Puma.run(app, Host: host, Port: port, Threads: "5:5", config_files: ['-'])
end

Capybara.server = :puma
Capybara.server_port = 3001
Capybara.app_host = 'http://localhost:3001'

ActiveSupport::TestCase.class_eval do
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  fixtures :all

  # Add more helper methods to be used by all tests here...
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

DatabaseCleaner.strategy = :deletion

class Minitest::Test
  include FactoryBot::Syntax::Methods
  include ActiveSupport::Testing::Assertions

  def setup
    DatabaseCleaner.clean
    DatabaseCleaner.start

    # we've started loading seeds by default to try to reduce any duplication of effort trying to get the test
    # environment to look the same as the actual development and production environments. this means a consolidation
    # of setup for things like the plans available for subscriptions and which outgoing webhooks are available to users.
    # Rails.application.load_seed
    load "#{Rails.root}/db/seeds.rb"

    ENV['BASE_URL'] = 'http://localhost:3001'

    @roles = [Role.admin, Role.create(key: :another_role_key, display_order: 1)]

    [
      Scaffolding::AbsolutelyAbstract::CreativeConcept,
      Scaffolding::CompletelyConcrete::TangibleThing,
    ].each do |model_class|
      ['created', 'updated', 'deleted'].each do |action|
        Webhooks::Outgoing::EventType.find_or_create_by(name: "#{model_class.name.underscore}.#{action}")
      end
    end

    Capybara.use_default_driver
    Capybara.reset_sessions!
  end

  def teardown
    Capybara.use_default_driver
    Capybara.reset_sessions!
    DatabaseCleaner.clean
  end

  def select2_select(label, string)
    string = string.join("\n") if string.is_a?(Array)
    field = find("label", :text => label)
    field.click
    "#{string}\n".split(//).each do |digit|
      within(field.find(:xpath, '..')) do
        find('.select2-search__field').send_keys(digit)
      end
    end
  end

  def calculate_resolution(display_details)
    # cut the display's pixel count in half if we're mimicking a high dpi display.
    display_details[:resolution].map { |pixel_count| pixel_count / (display_details[:high_dpi] ? 2 : 1) }
  end

end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Email::DSL
  include Capybara::Minitest::Assertions
  # include Capybara::Screenshot::MiniTestPlugin
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers
  include Waiting

  @@test_devices = {
    iphone_8: {resolution: [750, 1334], mobile: true, high_dpi: true},
    macbook_pro_15_inch: {resolution: [2880, 1800], mobile: false, high_dpi: true},
    # hd_monitor: {resolution: [1920, 1080], mobile: false, high_dpi: false},
  }

  if ENV['TEST_DEVICE']
    key = ENV['TEST_DEVICE'].to_sym
    if @@test_devices.keys.include?(key)
      puts "Running tests with the `#{ENV['TEST_DEVICE']}` device profile specifically.".green
      @@test_devices = {key => @@test_devices[key]}
    else
      puts "⚠️ `#{ENV['TEST_DEVICE']}` isn't a valid device profile in `test/test_helper.rb`, so we'll just run *all* device profiles.".yellow
    end
  end

  def resize_for(display_details)
    page.driver.browser.manage.window.resize_to(*calculate_resolution(display_details))
  end

  def within_team_menu_for(display_details)
    within_primary_menu_for(display_details) do
      if display_details[:mobile]
        click_on 'Team'
      else
        first(".icon-people").hover
      end
      yield
    end
  end

  def open_mobile_menu
    find(".mobile-menu-trigger").click
  end

  # sign out.
  def sign_out_for(display_details)
    if display_details[:mobile]
      open_mobile_menu
      click_on 'Logout'
    else
      within ".logged-user-w" do
        first(".logged-user-i").hover
        click_on 'Logout'
      end
    end
  end

  def sign_in_from_homepage_for(display_details)
    if display_details[:mobile]
      open_mobile_menu
      click_on 'Login'
    else
      within ".small-menu" do
        click_on 'Login'
      end
    end
  end

  def sign_up_from_homepage_for(display_details)
    # if the marketing site is hosted elsewhere, we just skip this step altogether.
    if ENV['MARKETING_SITE_URL'].present?
      visit new_user_registration_path
    else
      if display_details[:mobile]
        open_mobile_menu
        click_on 'Sign Up'
      else
        within ".small-menu" do
          click_on 'Sign Up'
        end
      end
    end

    # this forces capybara to wait until the proper page loads.
    # otherwise our tests will immediately start trying to match things before the page even loads.
    assert page.has_content?("Create Your Account")
  end

  def within_homepage_navigation_for(display_details)
    if display_details[:mobile]
      open_mobile_menu
      yield
    else
      yield
    end
  end

  def within_primary_menu_for(display_details)
    if display_details[:mobile]
      open_mobile_menu
      within ".menu-mobile .menu-and-user" do
        yield
      end
    else
      within ".menu-w .main-menu" do
        yield
      end
    end
  end

  def be_invited_to_sign_up
    # if the application is configured to only allow invitation-only sign-ups, visit the invitation url.
    visit invitation_path(key: invitation_keys.first) if invitation_only?
  end

end
