require "application_system_test_case"

class DatesHelperTest < ApplicationSystemTestCase
  unless scaffolding_things_disabled?
    @@test_devices.each do |device_name, display_details|
      test "Time is displayed correctly" do
        resize_for(display_details)
        be_invited_to_sign_up
        visit root_path

        # Sign up and log in
        sign_up_from_homepage_for(display_details)
        fill_in "Your Email Address", with: "bullettrain@gmail.com"
        fill_in "Set Password", with: example_password
        fill_in "Confirm Password", with: example_password
        click_on "Sign Up"
        fill_in "First Name", with: "Testy"
        fill_in "Last Name", with: "McTesterson"
        fill_in "Your Team Name", with: "The Testing Team"
        select "(GMT+00:00) UTC", from: "Your Time Zone"
        click_on "Next"

        if billing_enabled?
          unless freemium_enabled?
            complete_pricing_page
          end
        end

        # Create a Tangible Thing
        click_on "Creative Concepts"
        click_on "Add New Creative Concept"
        fill_in "Name", with: "Test Concept"
        fill_in "Description", with: "Test Description"
        click_on "Create Creative Concept"
        click_on "Add New Tangible Thing"
        fill_in "Text Field Value", with: "Test Tangible Thing"
        click_on "Create Tangible Thing"
        assert page.has_text? "Tangible Thing was successfully created."

        time = Scaffolding::CompletelyConcrete::TangibleThing.first.created_at

        # Go to the Tangible Thing's index page.
        click_on "Back"

        # Assert today's date is displayed correctly.
        assert page.has_text? I18n.l(time, format: :default)

        # Assert yesterday's date is displayed correctly.
        travel_to time + 1.day
        visit current_url # Refresh the page
        assert page.has_text? I18n.l(time, format: :default)

        # Create a new record in a different time zone.
        Time.zone = "Tokyo"

        # No need to check the strings on the page if the record
        # is successfully created and the times below are different.
        visit root_path
        click_on "Test Concept"
        click_on "Add New Tangible Thing"
        fill_in "Text Field Value", with: "Another Test Tangible Thing"
        click_on "Create Tangible Thing"
        assert page.has_text? "Tangible Thing was successfully created."

        # Compare by hours instead of seconds/minutes for accuracy.
        tokyo_time = Scaffolding::CompletelyConcrete::TangibleThing.find_by(text_field_value: "Another Test Tangible Thing").created_at
        refute time.strftime("%l").to_i == tokyo_time.strftime("%l").to_i

        # Even if we push UTC time forward by an hour,
        # it should still be behind Tokyo time.
        assert tokyo_time > (time + 1.hour)
      end
    end
  end
end
