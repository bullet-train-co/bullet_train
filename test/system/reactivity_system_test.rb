require "application_system_test_case"

class ReactivitySystemTest < ApplicationSystemTestCase
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

  device_test "create a new tangible thing and update it" do
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
    click_on "Skip" if bulk_invitations_enabled?

    if billing_enabled?
      unless freemium_enabled?
        complete_pricing_page
      end
    end

    # Ensure the user was able to sign up successfully.
    assert_text "My Super Team’s Dashboard"
    @team = Team.find_by(name: "My Super Team")

    visit account_team_scaffolding_absolutely_abstract_creative_concepts_path(@team)
    assert_text "If you're wondering what this"
    assert_text "Add New Creative Concept"

    # Open a new window. We'll bounce back and forth between these two to ensure updates are happening in both places.
    current_url = page.current_url
    second_window = open_new_window

    # We're going to do some activity and assertions within the new window.
    within_window second_window do
      visit current_url
      assert_text "My Super Team’s Creative Concepts"

      # Ensure we're on a page with no Creative Concepts listed.
      # (This sets us up to confirm that an entire table manifests out of nowhere.)
      assert_text "If you're wondering what this"
    end

    # We're now back on the regular window to take additional actions.
    click_on "Add New Creative Concept"

    fill_in "Name", with: "My Generic Creative Concept"
    fill_in "Description", with: "Dummy description for my creative concept"
    click_on "Create Creative Concept"

    assert_text "Creative Concept was successfully created."

    within_window second_window do
      # Ensure we're still on the same page.
      assert_text "My Super Team’s Creative Concepts"

      # But now the new Creative Concept should be present on the page.
      assert_text "My Generic Creative Concept"

      # Since we're already here, and the other window is already on the show page, let's edit from here so we can
      # ensure the show page is properly wired up as well.
      click_on "Edit"

      fill_in "Name", with: "My Updated Creative Concept"
      click_on "Update Creative Concept"

      assert_text "Creative Concept was successfully updated."
    end

    # Ensure this first tab hasn't been refreshed by ensuring it still has that original flash message on it.
    assert_text "Creative Concept was successfully created."

    # But also ensure the Creative Concept presentation has been updated.
    assert_text "My Updated Creative Concept"

    # Now for the final device_test, we need one of the tabs to be looking at the index.
    within_window second_window do
      click_on "Back"

      # Confirm that we're still looking at a populated list of Creative Concepts.
      assert_text "If you're wondering what this"
    end

    # Now that someone is looking at the index, let's destroy the Creative Concept.

    # click_on "Remove Creative Concept"

    # ☝️ This actually causes the device_test to fail because the page we're looking at receives the dirty signal before
    # the browser is redirected and tries to reload the very page we're looking on, which is then a 404. We'll have
    # to try and figure this scenario out. So for now, we'll do it like this, from the index page:

    click_on "Back"
    accept_alert { click_on "Delete" }

    assert_text "Creative Concept was successfully destroyed."
    assert_text "If you're wondering what this"

    # Now for the final device_test, we need one of the tabs to be looking at the index.
    within_window second_window do
      # Confirm that we're no longer looking at a populated list of Creative Concepts.
      assert_text "If you're wondering what this"
    end
  end
end
