require "application_system_test_case"

class InvitationListsTest < ApplicationSystemTestCase
  @@test_devices.each do |device_name, display_details|
    def setup
      @current_bulk_invitations_setting = nil
      BulletTrain.configure do |config|
        @current_bulk_invitations_setting = config.enable_bulk_invitations
        config.enable_bulk_invitations = true
      end
    end

    def teardown
      BulletTrain.configure do |config|
        config.enable_bulk_invitations = @current_bulk_invitations_setting
      end
    end

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
      assert page.has_content?("Email can't be blank")

      # Fill in the email addresses.
      email_fields = page.all("label", text: "Email Address")
      email_fields.each_with_index do |field, idx|
        field.sibling("div").find("input").fill_in with: "test-#{idx}@some-company.com"
      end

      # Select roles from select element.
      role_fields = page.all("label", text: "Role")
      role_fields.each do |role_field|
        select_field = role_field.sibling("div").find("select")
        select_field.select "admin"
        select_field.select "editor"
      end

      assert_difference(["Invitation.count", "Membership.count"], 1) do
        click_on "Next"
        sleep 2
      end

      assert page.has_content?("The Testing Team’s Dashboard")
      within_team_menu_for(display_details) do
        click_on "Team Members"
      end

      assert page.has_content?("test-0@some-company.com")
      invitation = Invitation.find_by(email: "test-0@some-company.com")
      assert_equal invitation.membership.role_ids, ["admin", "editor"]
    end
  end
end
