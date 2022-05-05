require "application_system_test_case"

class WebhooksSystemTest < ApplicationSystemTestCase
  def setup
    super
    @user = create :onboarded_user, first_name: "Andrew", last_name: "Culver"
    @another_user = create :onboarded_user, first_name: "John", last_name: "Smith"
  end

  unless scaffolding_things_disabled?

    @@test_devices.each do |device_name, display_details|
      test "team member registers for webhooks and then receives them on #{device_name}" do
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
        select2_select "Event Types", ["thing.create", "thing.update"]
        click_on "Create Endpoint"
        assert page.has_content?("Endpoint was successfully created.")

        # trigger the webhook event.
        within_primary_menu_for(display_details) do
          click_on "Creative Concepts"
        end

        assert page.has_content? "Your Team’s Creative Concepts"

        click_on "Add New Creative Concept"
        assert page.has_content? "New Creative Concept Details"

        assert_difference "Webhooks::Outgoing::Event.count", 0, "an outbound webhook event should not be issued" do
          fill_in "Name", with: "Testing"
          click_on "Create Creative Concept"
          assert page.has_content? "Creative Concept was successfully created"
        end

        assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook delivery should be issued" do
          click_on "Add New Tangible Thing"
          assert page.has_content? "New Tangible Thing Details"
          fill_in "Text Field Value", with: "Some Thing"
          click_on "Create Tangible Thing"
          assert page.has_content? "Tangible Thing was successfully created"
        end

        assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
          click_on "Add New Tangible Thing"
          fill_in "Text Field Value", with: "Some Other Thing"
          click_on "Create Tangible Thing"
          assert page.has_content? "Tangible Thing was successfully created"
          Webhooks::Outgoing::Delivery.order(:id).last.deliver
        end

        assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook should be issued" do
          click_on "Some Thing"
          assert page.has_content? "Tangible Thing Details"
          click_on "Edit Tangible Thing"
          assert page.has_content? "Edit Tangible Thing Details"
          fill_in "Text Field Value", with: "Some Updated Thing"
          click_on "Update Tangible Thing"
          assert page.has_content? "Tangible Thing was successfully updated"
        end

        assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
          click_on "Edit Tangible Thing"
          fill_in "Text Field Value", with: "One Last Updated Thing"
          click_on "Update Tangible Thing"
          assert page.has_content? "Tangible Thing was successfully updated"
          Webhooks::Outgoing::Delivery.order(:id).last.deliver
        end

        click_on "Back"

        assert_difference "Webhooks::Outgoing::Delivery.count", 0, "an outbound webhook should not be issued" do
          within("table tr:first-child[data-id]") do
            click_on "Delete"
          end
          page.driver.browser.switch_to.alert.accept
          assert page.has_content?("Tangible Thing was successfully destroyed.")
          Webhooks::Outgoing::Delivery.order(:id).last.deliver
        end

        sign_out_for(display_details)

        # create a thing as another user and confirm no webhooks are issued to the original user.
        login_as(@another_user, scope: :user)
        visit account_dashboard_path

        # trigger the webhook event.
        within_primary_menu_for(display_details) do
          click_on "Creative Concepts"
        end

        assert page.has_content? "Your Team’s Creative Concepts"

        click_on "Add New Creative Concept"
        assert page.has_content? "New Creative Concept Details"

        fill_in "Name", with: "Testing"
        click_on "Create Creative Concept"
        assert page.has_content? "Creative Concept was successfully created"

        # make sure that when a user takes an action that would trigger a webhook event that another user's has an
        # endpoint configured to receive, that the webhooks don't bleed across teams.
        assert_difference "Webhooks::Outgoing::Delivery.count", 0, "an outbound webhook should not be issued" do
          click_on "Add New Tangible Thing"
          fill_in "Text Field Value", with: "Some Thing"
          click_on "Create Tangible Thing"
          assert page.has_content?("Tangible Thing was successfully created.")
        end

        # create the endpoint.
        within_primary_menu_for(display_details) do
          click_on "Webhooks"
        end
        click_on "Add New Endpoint"
        fill_in "Name", with: "Some Bullet Train App"
        fill_in "URL", with: "#{Capybara.app_host}/webhooks/incoming/bullet_train_webhooks"
        click_on "Create Endpoint"
        assert page.has_content?("Endpoint was successfully created.")

        # trigger the webhook event.
        within_primary_menu_for(display_details) do
          click_on "Creative Concepts"
        end

        assert page.has_content? "Your Team’s Creative Concepts"

        click_on "Testing"
        assert page.has_content? "Creative Concept Details"

        assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
          assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook should not be issued" do
            within("table tr:first-child[data-id]") do
              click_on "Delete"
            end
            page.driver.browser.switch_to.alert.accept
            assert page.has_content?("Tangible Thing was successfully destroyed.")
          end
          Webhooks::Outgoing::Delivery.order(:id).last.deliver
        end
      end
    end

  end
end
