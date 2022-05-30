require "application_system_test_case"

class DatesHelperTest < ApplicationSystemTestCase
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

      # Assert today's date is displayed correctly.
      assert page.has_text? "Today at #{time.strftime("%l:%M %p").strip}"

      # Assert yesterday's date is displayed correctly.
      travel_to time + 1.day
      visit current_url # Refresh the page
      assert page.has_text? "Yesterday at #{(time).strftime("%l:%M %p").strip}"

      # Assert the month and day is shown for anything before then.
      travel_to time + 2.days
      visit current_url
      assert page.has_text? "#{time.strftime("%B %-d").strip} at #{time.strftime("%l:%M %p").strip}"

      # TODO: Write test for a user with a different time zone
    end
  end
end
