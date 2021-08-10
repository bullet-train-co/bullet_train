require "application_system_test_case"

class WebhooksSystemTest < ApplicationSystemTestCase
  def setup
    super
    @user = create :onboarded_user, first_name: "Andrew", last_name: "Culver"

    # we have to make sure the api keys the ones from the environment so the
    # server can use them to verify the authenticity of incoming webhooks.
    @api_key = @user.api_keys.create
    @api_key.token = ENV["BULLET_TRAIN_API_KEY"]
    @api_key.save

    @api_key.generate_encrypted_secret(ENV["BULLET_TRAIN_API_SECRET"])

    @another_user = create :onboarded_user, first_name: "John", last_name: "Smith"
  end

  unless scaffolding_things_disabled?

    @@test_devices.each do |device_name, display_details|
      test "team member registers for webhooks and then receives them on #{device_name}" do
        skip "i wish i knew why this test stopped being able to connect to itself in rails 6"

        resize_for(display_details)
        login_as(@user, scope: :user)
        visit account_dashboard_path

        # create the endpoint.
        within_primary_menu_for(display_details) do
          click_on "Webhooks"
        end
        click_on "Add New Endpoint"
        fill_in "Name", with: "Some Bullet Train App"
        fill_in "URL", with: "#{Capybara.app_host}/webhooks/incoming/bullet_train_webhooks"
        select2_select "Event Types to Deliver", ["create", "update"]
        click_on "Create Endpoint"
        assert page.has_content?("Endpoint was successfully created.")

        # trigger the webhook event.
        within_primary_menu_for(display_details) do
          click_on "Things"
        end

        assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook should be issued" do
          click_on "Add New Thing"
          fill_in "Name", with: "Some Thing"
          click_on "Create Thing"
          assert page.has_content?("Thing was successfully created.")
        end

        assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
          click_on "Add New Thing"
          fill_in "Name", with: "Some Other Thing"
          click_on "Create Thing"
          assert page.has_content?("Thing was successfully created.")
        end

        assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook should be issued" do
          click_on "Some Thing"
          click_on "Edit"
          fill_in "Name", with: "Some Updated Thing"
          click_on "Update Thing"
          assert page.has_content?("Thing was successfully updated.")
        end

        assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
          click_on "Edit"
          fill_in "Name", with: "One Last Updated Thing"
          click_on "Update Thing"
          assert page.has_content?("Thing was successfully updated.")
        end

        click_on "Back"

        assert_difference "Webhooks::Outgoing::Delivery.count", 0, "an outbound webhook should not be issued" do
          within("table[data-class='Scaffolding::Thing'] tr:first-child[data-id]") do
            click_on "Delete"
          end
          page.driver.browser.switch_to.alert.accept
          assert page.has_content?("Thing was successfully destroyed.")
        end

        sign_out_for(display_details)

        # create a thing as another user and confirm no webhooks are issued to the original user.
        login_as(@another_user, scope: :user)
        visit account_dashboard_path

        # do something that _could_ trigger a webhook event, (but shouldn't.)
        within_primary_menu_for(display_details) do
          click_on "Things"
        end

        # make sure that when a user takes an action that would trigger a webhook event that another user's has an
        # endpoint configured to receive, that the webhooks don't bleed across teams.
        assert_difference "Webhooks::Outgoing::Delivery.count", 0, "an outbound webhook should not be issued" do
          click_on "Add New Thing"
          fill_in "Name", with: "Some Thing"
          click_on "Create Thing"
          assert page.has_content?("Thing was successfully created.")
        end
      end
    end

  end
end
