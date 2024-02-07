require "application_system_test_case"

class FieldsTest < ApplicationSystemTestCase
  def setup
    super
    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  device_test "simulate restoring behavior of form fields on page restore" do
    new_session_page_for(display_details)
    invitation_only? ? be_invited_to_sign_up : click_on("Don't have an account?")
    assert_text("Create Your Account")
    fill_in "Your Email Address", with: "me@acme.com"
    fill_in "Set Password", with: example_password
    fill_in "Confirm Password", with: example_password
    click_on "Sign Up"
    fill_in "Your First Name", with: "John"
    fill_in "Your Last Name", with: "Doe"
    fill_in "Your Team Name", with: "My Super Team"
    page.select "Brisbane", from: "Your Time Zone"
    click_on "Next"
    click_on "Skip" if bulk_invitations_enabled?

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    click_on "Add New Creative Concept"
    fill_in "Name", with: "My Generic Creative Concept"
    fill_in "Description", with: "Dummy description for my creative concept"
    click_on "Create Creative Concept"

    click_on "Add New Tangible Thing"

    select2_select "Multiple Super Select Values", ["Five", "Six"]
    super_select = find_stimulus_controller_for_label "Multiple Super Select Values", "fields--super-select"
    assert_no_js_errors do
      disconnect_stimulus_controller_on super_select
      reconnect_stimulus_controller_on super_select
      improperly_disconnect_and_reconnect_stimulus_controller_on super_select
      select2_select "Multiple Super Select Values", ["Four"]
      assert super_select.has_css?(".select2-container--default", count: 1)
    end

    button = find_stimulus_controller_for_label "Button Value", "fields--button-toggle"
    click_on "One"
    assert_no_js_errors do
      disconnect_stimulus_controller_on button
      reconnect_stimulus_controller_on button
      assert button.find('input[type="radio"]', visible: false)["checked"]
      improperly_disconnect_and_reconnect_stimulus_controller_on button # the radio button won't be checked because we're using innerHTML
    end

    phone_field_wrapper = find_stimulus_controller_for_label "Phone Field Value", "fields--phone", wrapper: true
    phone_field = phone_field_wrapper.first("input")
    "+1 613".chars.each do |digit|
      phone_field.send_keys(digit)
    end
    assert_no_js_errors do
      disconnect_stimulus_controller_on phone_field_wrapper
      reconnect_stimulus_controller_on phone_field_wrapper
      improperly_disconnect_and_reconnect_stimulus_controller_on phone_field_wrapper
      assert phone_field_wrapper.first(".iti__selected-flag")["title"] == "Canada: +1"
    end

    date_field = find_stimulus_controller_for_label "Date Field Value", "fields--date"
    assert_no_js_errors do
      disconnect_stimulus_controller_on date_field
      reconnect_stimulus_controller_on date_field
      improperly_disconnect_and_reconnect_stimulus_controller_on date_field
    end
  end
end
