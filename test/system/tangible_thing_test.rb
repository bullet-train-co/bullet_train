require "application_system_test_case"

unless scaffolding_things_disabled?
  class TangibleThingTest < ApplicationSystemTestCase
    @@test_devices.each do |device_name, display_details|
      test "create a new tangible thing on a #{device_name} and update it" do
        resize_for(display_details)

        visit user_session_path

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

        if billing_enabled?
          unless freemium_enabled?
            complete_pricing_page
          end
        end

        visit edit_account_user_path(User.find_by!(email: "me@acme.com"))
        page.select "Tokyo", from: "Your Time Zone"
        click_on "Update Profile"
        visit account_teams_path(Team.find_by!(name: "My Super Team"))

        click_on "Add New Creative Concept"
        fill_in "Name", with: "My Generic Creative Concept"
        fill_in "Description", with: "Dummy description for my creative concept"
        click_on "Create Creative Concept"

        click_on "Add New Tangible Thing"
        fill_in "Text Field Value", with: "My value for this text field"
        click_on "Yes"
        click_on "Two" # this should never make it to the database, because of what comes next.
        click_on "Three"
        click_on "Four"
        click_on "Five"
        page.all('input[id^="scaffolding_completely_concrete_tangible_thing_date_field_value"]').each do |el|
          el.click
        end
        find(".daterangepicker").click_on("Apply")
        page.all('input[id^="scaffolding_completely_concrete_tangible_thing_date_and_time_field_value"]').each do |el|
          el.click
        end
        find(".daterangepicker").click_on("Apply")
        fill_in "Email Field Value", with: "me@acme.com"
        fill_in "Password Field Value", with: "secure-password"
        fill_in "Phone Field Value", with: "(201) 551-8321"

        assert page.has_content? "State / Province"
        select "Japan", from: "Country"
        assert page.has_content? "Prefecture"

        select "One", from: "Super Select Value"
        select2_select "Multiple Super Select Values", ["Five", "Six"]
        fill_in "Text Area Value", with: "Long text for this text area field"

        click_on "Create Tangible Thing"
        assert_text "Tangible Thing was successfully created."

        # Creating a Tangible Thing redirects to its show page.
        assert_text "Tangible Thing Details"

        assert_text "My value for this text field"
        assert_text "Yes"
        assert page.has_no_content? "Two"
        assert_text "Three"
        assert_text "Four and Five"
        assert_text "me@acme.com"
        assert_text "secure-password"
        assert_text "+1 201-551-8321"
        assert_text "One"
        assert_text "Five and Six"
        assert_text "Long text for this text area field"

        click_on "Edit Tangible Thing"

        fill_in "Text Field Value", with: "My new value for this text field"
        click_on "No"
        click_on "One"
        fill_in "Date Field Value", with: "02/17/2021"
        fill_in "Date and Time Field Value", with: "08/15/2023 8:00 PM"

        fill_in "Email Field Value", with: "not-me@acme.com"
        fill_in "Password Field Value", with: "insecure-password"
        fill_in "Phone Field Value", with: "(231) 832-5512"
        page.select "Two", from: "Super Select Value"
        fill_in "Text Area Value", with: "New long text for this text area field"

        click_on "Update Tangible Thing"

        assert_text "My new value for this text field"
        assert_text "No"
        assert_text "One"
        assert_text "not-me@acme.com"
        assert_text "insecure-password"
        assert_text "+1 231-832-5512"
        assert_text "Two"
        assert_text "New long text for this text area field"
      end
    end
  end
end
