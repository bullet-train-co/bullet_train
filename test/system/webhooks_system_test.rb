require "application_system_test_case"

class WebhooksSystemTest < ApplicationSystemTestCase
  def setup
    super
    @user = create :onboarded_user, first_name: "Andrew", last_name: "Culver"
    @another_user = create :onboarded_user, first_name: "John", last_name: "Smith"
    return unless Rails.configuration.respond_to?(:outgoing_webhooks)

    Rails.configuration.outgoing_webhooks[:allowed_hostnames] = [URI.parse(Capybara.app_host).host]
    Rails.configuration.outgoing_webhooks[:blocked_hostnames] = []

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  device_test "team member registers for webhooks and then receives them" do
    login_as(@user, scope: :user)

    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end

    visit account_dashboard_path

    # create the endpoint.
    if disable_developer_menu?
      visit account_team_webhooks_outgoing_endpoints_path(@user.current_team)
    else
      within_developers_menu_for(display_details) do
        click_on "Webhooks"
      end
    end
    click_on "Add New Endpoint"
    fill_in "Name", with: "Some Bullet Train App"
    fill_in "URL", with: "#{Capybara.app_host}/webhooks/incoming/bullet_train_webhooks"
    select2_select "Event Types", ["thing.create", "thing.update"]
    click_on "Create Endpoint"
    assert_text("Endpoint was successfully created.")

    # trigger the webhook event.
    within_primary_menu_for(display_details) do
      click_on "Creative Concepts"
    end

    assert_text "Your Team’s Creative Concepts"

    click_on "Add New Creative Concept"
    assert_text "New Creative Concept Details"

    assert_difference "Webhooks::Outgoing::Event.count", 0, "an outbound webhook event should not be issued" do
      fill_in "Name", with: "Testing"
      click_on "Create Creative Concept"
      assert_text "Creative Concept was successfully created"

      perform_enqueued_jobs
    end

    assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook delivery should be issued" do
      click_on "Add New Tangible Thing"
      assert_text "New Tangible Thing Details"
      fill_in "Text Field Value", with: "Some Thing"
      click_on "Create Tangible Thing"
      assert_text "Tangible Thing was successfully created"

      perform_enqueued_jobs
    end

    # Go to index page.
    click_on "Back"

    assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
      click_on "Add New Tangible Thing"
      fill_in "Text Field Value", with: "Some Other Thing"
      click_on "Create Tangible Thing"
      assert_text "Tangible Thing was successfully created"

      perform_enqueued_jobs
    end

    assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook should be issued" do
      assert_text "Tangible Thing Details"
      click_on "Edit Tangible Thing"
      assert_text "Edit Tangible Thing Details"
      fill_in "Text Field Value", with: "Some Updated Thing"
      click_on "Update Tangible Thing"
      assert_text "Tangible Thing was successfully updated"

      perform_enqueued_jobs
    end

    assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
      click_on "Edit Tangible Thing"
      fill_in "Text Field Value", with: "One Last Updated Thing"
      click_on "Update Tangible Thing"
      assert_text "Tangible Thing was successfully updated"

      perform_enqueued_jobs
    end

    click_on "Back"

    assert_difference "Webhooks::Outgoing::Delivery.count", 0, "an outbound webhook should not be issued" do
      within("table tr:first-child[data-id]") do
        accept_alert { click_on "Delete" }
      end
      assert_text("Tangible Thing was successfully destroyed.")

      perform_enqueued_jobs
    end

    sign_out_for(display_details)

    # create a thing as another user and confirm no webhooks are issued to the original user.
    login_as(@another_user, scope: :user)
    visit root_path
    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
        sleep 2
      end
    end

    visit account_dashboard_path

    # trigger the webhook event.
    within_primary_menu_for(display_details) do
      click_on "Creative Concepts"
    end

    assert_text "Your Team’s Creative Concepts"

    click_on "Add New Creative Concept"
    assert_text "New Creative Concept Details"

    fill_in "Name", with: "Testing"
    click_on "Create Creative Concept"
    assert_text "Creative Concept was successfully created"

    # make sure that when a user takes an action that would trigger a webhook event that another user's has an
    # endpoint configured to receive, that the webhooks don't bleed across teams.
    assert_difference "Webhooks::Outgoing::Delivery.count", 0, "an outbound webhook should not be issued" do
      click_on "Add New Tangible Thing"
      fill_in "Text Field Value", with: "Some Thing"
      click_on "Create Tangible Thing"
      assert_text("Tangible Thing was successfully created.")

      perform_enqueued_jobs
    end

    # create the endpoint.
    if disable_developer_menu?
      visit account_team_webhooks_outgoing_endpoints_path(@another_user.current_team)
    else
      within_developers_menu_for(display_details) do
        click_on "Webhooks"
      end
    end
    click_on "Add New Endpoint"
    fill_in "Name", with: "Some Bullet Train App"
    fill_in "URL", with: "#{Capybara.app_host}/webhooks/incoming/bullet_train_webhooks"
    click_on "Create Endpoint"
    assert_text("Endpoint was successfully created.")

    # trigger the webhook event.
    within_primary_menu_for(display_details) do
      click_on "Creative Concepts"
    end

    assert_text "Your Team’s Creative Concepts"

    click_on "Testing"
    assert_text "Creative Concept Details"

    assert_difference "Webhooks::Incoming::BulletTrainWebhook.count", 1, "an inbound webhook should be received" do
      assert_difference "Webhooks::Outgoing::Delivery.count", 1, "an outbound webhook should be issued" do
        within("table tr:first-child[data-id]") do
          accept_alert { click_on "Delete" }
        end
        assert_text("Tangible Thing was successfully destroyed.")
        perform_enqueued_jobs
      end

      perform_enqueued_jobs
    end

    if disable_developer_menu?
      visit account_team_webhooks_outgoing_endpoints_path(@another_user.current_team)
    else
      within_developers_menu_for(display_details) do
        click_on "Webhooks"
      end
    end

    within("table tr:first-child[data-id]") do
      find("td:first-child a").click
    end

    assert_text("Webhooks Endpoint Details")

    within("table tr:first-child[data-id]") do
      find("td:first-child a").click
    end

    assert_text("Webhook Delivery Details")

    # View a delivery attempt.
    within("table tr:first-child[data-id]") do
      find("td:first-child a").click
    end

    assert_text("Delivery Attempt Details")
  end
end
