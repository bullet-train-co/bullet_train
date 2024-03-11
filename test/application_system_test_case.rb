require "test_helper"
require "capybara/email"
require "support/waiting"
require "minitest/retry"

Minitest::Retry.use!(retry_count: 3, verbose: true, exceptions_to_retry: [Net::ReadTimeout])
OmniAuth.config.test_mode = true

# Configure Capybara with either cuprite or selenium based on what gems are installed
if Bundler.locked_gems.dependencies.has_key? "cuprite"
  require "capybara/cuprite"
  require "support/ferrum_console_logger"

  Capybara.register_driver(:bt_cuprite) do |app|
    Capybara::Cuprite::Driver.new(
      app,
      logger: FerrumConsoleLogger.new,
      window_size: [1400, 1400],
      process_timeout: 10,
      inspector: true,
      headless: !ENV["HEADLESS"].in?(%w[n 0 no false]) && !ENV["MAGIC_TEST"].in?(%w[y 1 yes true]),
    )
  end
  Capybara.default_driver = Capybara.javascript_driver = :bt_cuprite
else # Selenium
  Capybara.javascript_driver = ENV["MAGIC_TEST"].present? ? :selenium_chrome : :selenium_chrome_headless
  Capybara.default_driver = ENV["MAGIC_TEST"].present? ? :selenium_chrome : :selenium_chrome_headless
end

Capybara.default_max_wait_time = ENV.fetch("CAPYBARA_DEFAULT_MAX_WAIT_TIME", ENV["MAGIC_TEST"].present? ? 5 : 15)

Capybara.register_server :puma do |app, port, host|
  require "rack/handler/puma"
  # current we need at least three threads for the webhooks tests to pass.
  Rack::Handler::Puma.run(app, Host: host, Port: port, Threads: "5:5", config_files: ["-"])
end

Capybara.server = :puma
Capybara.server_port = 3001
Capybara.app_host = "http://localhost:3001"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  def self.use_cuprite?
    Bundler.locked_gems.dependencies.has_key? "cuprite"
  end
  delegate :use_cuprite?, to: :class

  if use_cuprite?
    driven_by :bt_cuprite
  else
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  end
  include ActiveJob::TestHelper
  include MagicTest::Support
  include Capybara::DSL
  include Capybara::Email::DSL
  include Capybara::Minitest::Assertions
  # include Capybara::Screenshot::MiniTestPlugin
  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers
  include Waiting

  # Capybara::Lockstep.debug = true # Uncomment to inspect and verify the integration in your app.

  def example_password
    @example_password ||= SecureRandom.hex
  end

  def another_example_password
    @another_example_password ||= SecureRandom.hex
  end

  def setup
    ENV["BASE_URL"] = "http://localhost:3001"
    Capybara.use_default_driver
    Capybara.reset_sessions!
  end

  def teardown
    Capybara.use_default_driver
    Capybara.reset_sessions!
  end

  @@test_devices = {
    # iphone_8: {resolution: [750, 1334], mobile: true, high_dpi: true},
    macbook_pro_15_inch: {resolution: [2880, 1800], mobile: false, high_dpi: true},
    # hd_monitor: {resolution: [1920, 1080], mobile: false, high_dpi: false},
  }

  if ENV["TEST_DEVICE"]
    key = ENV["TEST_DEVICE"].to_sym
    if @@test_devices.key?(key)
      puts "Running tests with the `#{ENV["TEST_DEVICE"]}` device profile specifically.".green
      @@test_devices = @@test_devices.slice(key)
    else
      puts "⚠️ `#{ENV["TEST_DEVICE"]}` isn't a valid device profile in `test/test_helper.rb`, so we'll just run *all* device profiles.".yellow
    end
  end

  def device_name
    @device_name ||= @@test_devices.each_key.find { name.include?(_1.to_s) } || raise("unknown test device, you probably want to use `device_test` to generate this test")
  end

  def display_details
    @@test_devices[device_name]
  end

  # Generate a device specific test for each device in `@@test_devices`.
  #
  # Automatically resizes the display for the test too.
  #
  #   device_test "system test" do
  #     p device_name
  #     p display_details
  #   end
  def self.device_test(name, &block)
    # All this is because Rails' `test` method uses `define_method`, which will report this file as the `source_location`
    # and not the target test file where the test is actually defined.
    #
    # `define_method` cannot be passed the correct location, we must use `class_eval` with a source string of Ruby for that.
    # But using a string means we can't refer to the block, like `define_method(name, &block)` would.
    #
    # So we inject a module that we define methods via `test` to pass the block to, then we override that
    # via `class_eval` to point it to the correct location.
    location = caller_locations(1, 1).first

    name = name.remove(/[^\w ]/) # `def` is stricter than `define_method` so we have to scrub characters.
    @device_test_methods ||= Module.new.tap { include _1 }

    @@test_devices.each_key do |device_name|
      test_name = ActiveSupport::Testing::Declarative.instance_method(:test).bind_call(@device_test_methods, "#{name} on a #{device_name}", &block)

      # Standard recommends __FILE__ and __LINE__ + 1 here, which points to `application_system_test_case.rb`. It's wrong.
      # TODO: Figure out why the browser window opens if `resize_display` is done in `setup`.
      class_eval <<~RUBY, location.path, location.lineno # standard:disable Style/EvalWithLocation
        def #{test_name}; resize_display; super; end # Use single line to match source line numbers properly.
      RUBY
    end
  end

  def resize_for(display_details)
    ActiveSupport::Deprecation.warn <<~END_OF_MESSAGE
      `resize_for` is deprecated.
      Please run the following command to update your tests:
      ./bin/updates/system_tests/use_device_test
    END_OF_MESSAGE
    resize_display(display_details)
  end

  def resize_display(display_details = self.display_details)
    if use_cuprite?
      page.driver.resize(*calculate_resolution(display_details))
    else
      page.driver.browser.manage.window.resize_to(*calculate_resolution(display_details))
    end
  end

  def within_team_menu(display_details = self.display_details)
    first("#team").hover
    yield
  end
  alias_method :within_team_menu_for, :within_team_menu

  def within_user_menu(display_details = self.display_details)
    find("#user").hover
    yield
  end
  alias_method :within_user_menu_for, :within_user_menu

  def within_developers_menu(display_details = self.display_details)
    find("#developers").hover
    yield
  end
  alias_method :within_developers_menu_for, :within_developers_menu

  def within_membership_row(membership)
    within "tr[data-id='#{membership.id}']" do
      yield
    end
  end

  def within_current_memberships_table
    within "tbody[data-model='Membership'][data-scope='current']" do
      yield
    end
  end

  def within_former_memberships_table
    within "tbody[data-model='Membership'][data-scope='tombstones']" do
      yield
    end
  end

  def open_mobile_menu
    find("#mobile-menu-open").click
  end

  # sign out.
  def sign_out(display_details = self.display_details)
    if display_details[:mobile]
      open_mobile_menu
    else
      find("#user").hover
    end
    click_on "Logout"

    # make sure we're actually signed out.
    assert_text(/Signed out successfully|You need to sign in or sign up before continuing/)
  end
  alias_method :sign_out_for, :sign_out

  def new_session_page(display_details = self.display_details)
    # We actually want to go straight to the user session and
    # not the home page in case the home page doesn't have new session logic.
    visit new_user_session_path

    # this forces capybara to wait until the proper page loads.
    # otherwise our tests will immediately start trying to match things before the page even loads.
    assert_text("Sign In")
  end
  alias_method :new_session_page_for, :new_session_page

  def sign_in_from_homepage(display_details = self.display_details)
    puts "#{__callee__} is deprecated".red
    puts "  please switch to: new_session_page".red
    puts "  called from #{caller(1..1).first}".red
    new_session_page_for(display_details)
  end
  alias_method :sign_in_from_homepage_for, :sign_in_from_homepage

  def new_registration_page(display_details = self.display_details)
    # TODO: Adjust tests to start from the home page.
    # Ensure no one is signed in before trying to register a new account.
    logout

    visit new_user_registration_path

    if invitation_only?
      assert_text("You need to sign in or sign up before continuing.")
      refute_text("Create Your Account")
      visit invitation_path(key: ENV["INVITATION_KEYS"].split(",\s+").first)
    end

    # this forces capybara to wait until the proper page loads.
    # otherwise our tests will immediately start trying to match things before the page even loads.
    assert_text("Create Your Account")
  end
  alias_method :new_registration_page_for, :new_registration_page

  def sign_up_from_homepage(display_details = self.display_details)
    puts "#{__callee__} is deprecated".red
    puts "  please switch to: new_registration_page".red
    puts "  called from #{caller(1..1).first}".red
    new_registration_page_for(display_details)
  end
  alias_method :sign_up_from_homepage_for, :sign_up_from_homepage

  def within_homepage_navigation(display_details = self.display_details)
    if display_details[:mobile]
      open_mobile_menu
    end
    yield
  end
  alias_method :within_homepage_navigation_for, :within_homepage_navigation

  def within_primary_menu(display_details = self.display_details)
    open_mobile_menu if display_details[:mobile]
    within ".menu" do
      yield
    end
  end
  alias_method :within_primary_menu_for, :within_primary_menu

  def be_invited_to_sign_up
    # if the application is configured to only allow invitation-only sign-ups, visit the invitation url.
    visit invitation_path(key: invitation_keys.first) if invitation_only?
  end

  def select2_select(label, string)
    if use_cuprite?
      select2_select_cuprite(label, string)
    else
      select2_select_selenium(label, string)
    end
  end

  private def select2_select_cuprite(label, string)
    string = string.join("\n") if string.is_a?(Array)
    field = find("label", text: /\A#{label}\z/)
    field.click
    page.driver.browser.keyboard.type(string, :Enter)
  end

  private def select2_select_selenium(label, string)
    string = string.join("\n") if string.is_a?(Array)
    field = find("label", text: /\A#{label}\z/)
    field.click
    "#{string}\n".chars.each do |digit|
      within(field.find(:xpath, "..")) do
        find(".select2-search__field").send_keys(digit)
      end
    end
  end

  # https://stackoverflow.com/a/50794401/2414273

  # Anonymous block forwarding was introduced in ruby 3.1, and then standardrb
  # added it as a rule. In case downstream apps are still using ruby 3.0.x
  # we're going to disable this rule for now.
  # standard:disable Style/ArgumentsForwarding
  def assert_no_js_errors &block
    if use_cuprite?
      assert_no_js_errors_cuprite(&block)
    else
      assert_no_js_errors_selenium(&block)
    end
  end
  # standard:enable Style/ArgumentsForwarding

  private def assert_no_js_errors_cuprite &block
    last_timestamp = page.driver.browser.options.logger.logs
      .map(&:timestamp)
      .last || 0

    yield

    errors = page.driver.browser.options.logger.logs

    errors = errors.reject { |e| e.timestamp.blank? || e.timestamp < last_timestamp } if last_timestamp > 0
    errors = errors.filter { |e| e.level == "error" }

    assert errors.length.zero?, "Expected no js errors, but these errors where found: #{errors.map(&:message).join(", ")}"
  end

  private def assert_no_js_errors_selenium &block
    last_timestamp = page.driver.browser.logs.get(:browser)
      .map(&:timestamp)
      .last || 0

    yield

    errors = page.driver.browser.logs.get(:browser)
    errors = errors.reject { |e| e.timestamp > last_timestamp } if last_timestamp > 0
    errors = errors.reject { |e| e.level == "WARNING" }

    assert errors.length.zero?, "Expected no js errors, but these errors where found: #{errors.join(", ")}"
  end

  def find_stimulus_controller_for_label(label, stimulus_controller, wrapper = false)
    if wrapper
      wrapper_el = find("label", text: /\A#{label}\z/).first(:xpath, ".//..//..")
      wrapper_el if wrapper_el["data-controller"].split(" ").include?(stimulus_controller)
    else
      find("label", text: /\A#{label}\z/).first(:xpath, ".//..").first('[data-controller~="' + stimulus_controller + '"]')
    end
  end

  def set_element_attribute(element, attribute, value)
    page.evaluate_script(<<~JS, element, attribute, value)
      (function(element, attribute, value){
        element.setAttribute(attribute, value)
      })(arguments[0], arguments[1], arguments[2])
    JS
  end

  def disconnect_stimulus_controller_on(element)
    set_element_attribute(element, "data-former-controller", element["data-controller"])
    set_element_attribute(element, "data-controller", "")
  end

  def reconnect_stimulus_controller_on(element)
    set_element_attribute(element, "data-controller", element["data-former-controller"])
  end

  def improperly_disconnect_and_reconnect_stimulus_controller_on(element)
    inner_html_before_disconnect = element["innerHTML"]

    disconnect_stimulus_controller_on(element)

    page.evaluate_script(<<~JS, element, inner_html_before_disconnect)
      (function(element, innerHTML){
        element.innerHTML = innerHTML
      })(arguments[0], arguments[1])
    JS

    reconnect_stimulus_controller_on(element)
  end

  def calculate_resolution(display_details)
    # cut the display's pixel count in half if we're mimicking a high dpi display.
    display_details[:resolution].map { |pixel_count| pixel_count / (display_details[:high_dpi] ? 2 : 1) }
  end

  def complete_pricing_page(card = nil)
    assert_text("The Pricing Page")
    sleep 0.5
    start_subscription
    complete_payment_page(card)
  end

  def complete_payment_page(card = nil)
    # we should be on the credit card page.
    assert_text("Subscribe to #{I18n.t("application.name")} Pro")
    fill_in_stripe_elements(card)
    click_on "Subscribe"
    sleep 3
  end

  def start_subscription
    click_on "Select"
  end

  def fill_in_stripe_elements(card = nil)
    # default card.
    card ||= {
      card_number: "4242424242424242",
      expiration_month: "12",
      expiration_year: "29",
      security_code: "234",
      zip: "93063"
    }

    using_wait_time(10) do
      fill_in placeholder: "1234 1234 1234 1234", with: card[:card_number]
      fill_in placeholder: "MM / YY", with: card[:expiration_month] + card[:expiration_year]
      fill_in placeholder: "CVC", with: card[:security_code]
      fill_in "Name on card", with: "Hanako"
    end
  end

  if !use_cuprite?
    module ::Selenium::WebDriver::Remote
      class Bridge
        @@execute_sleep_time = 0
        alias_method :patched_execute, :execute
        def execute(*)
          sleep @@execute_sleep_time
          patched_execute(*)
        end

        def self.slow_down_execute_time
          @@execute_sleep_time = 0.1
        end

        def self.reset_execute_time
          @@execute_sleep_time = 0
        end
      end
    end
  end
end
