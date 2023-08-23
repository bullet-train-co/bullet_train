require "application_system_test_case"

class InvitationListsTest < ApplicationSystemTestCase
  if bulk_invitations_enabled?
    @@test_devices.each do |device_name, display_details|
      test "visitors can send bulk invitations upon signing up" do
        resize_for(display_details)

        sign_up_from_homepage_for(display_details)
        fill_in "Your Email Address", with: "hanako.tanaka@gmail.com"
        fill_in "Set Password", with: example_password
        fill_in "Confirm Password", with: example_password
        click_on "Sign Up"

        assert page.has_content?("Tell us about you")
        fill_in "First Name", with: "Hanako"
        fill_in "Last Name", with: "Tanaka"
        fill_in "Your Team Name", with: "The Testing Team"
        click_on "Next"

        if billing_enabled?
          unless freemium_enabled?
            complete_pricing_page
          end
        end

        # Click on next to show that bulk invitations will raise an error if not filled out properly.
        click_on "Next"
        assert page.has_content?("Please correct the errors below.")
        assert page.has_content?("Invitations email can't be blank")

        # Fill in the email addresses.
        email_fields = page.all("label", text: "Email Address")
        email_fields.each_with_index do |field, idx|
          field.sibling("div").find("input").fill_in with: "test-#{idx}@some-company.com"
        end

        # Select roles from select element.
        role_ids = ["Default", "Editor", "Admin"]
        role_fields = page.all("label", text: "Role ids")
        role_fields.each_with_index do |role_field, idx|
          select_field = role_field.sibling("div").find("select")
          select_field.all("option").find { |opt| opt.text == role_ids[idx] }.select_option
        end

        assert_difference(["Invitation.count", "Membership.count"], 3) do
          click_on "Next"
          sleep 2
        end

        assert page.has_content?("The Testing Team’s Dashboard")
        within_team_menu_for(display_details) do
          click_on "Team Members"
        end

        3.times do |idx|
          assert page.has_content?("test-#{idx}@some-company.com")
          invitation = Invitation.find_by(email: "test-#{idx}@some-company.com")
          assert_equal invitation.membership.role_ids, [role_ids[idx].downcase]
        end
      end
    end
  end
end
