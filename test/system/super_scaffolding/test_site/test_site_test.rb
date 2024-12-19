require "application_system_test_case"

class BulletTrain::SuperScaffolding::TestSiteTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

  # force autoload.
  [
    "TestSite",
    "TestPage"
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
  end

  if defined?(TestSite)
    test "developers can generate a TestSite and a nested TestPage model" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      assert_text("Test Sites")
      click_on "Add New Test Site"

      assert_text("New Test Site Details")
      fill_in "Name", with: "Some New Example Site"
      fill_in "Other Attribute", with: "Some Other Value"
      fill_in "Url", with: "http://example.org/test"

      click_on "Create Test Site"
      click_on "Back"

      assert_text "Below is a list of Test Sites that have been added for Your Team."

      # Edit the first test site.
      within "table", match: :first do
        click_on "Edit", match: :first
      end

      assert_text "Edit Test Site Details"

      # Select the membership we created.
      find("#select2-test_site_membership_id-container").click
      find("li.select2-results__option span", text: "Jane Smith").click
      click_on "Update Test Site"

      # Test the has-many-through scaffolding.
      assert_text "Test Site was successfully updated."

      # make sure the content is being displayed on the show partial.
      assert_text("Test Site Details")
      assert_text("Some New Example Site")
      assert_text("http://example.org/test")
      click_on "Back"

      # we're now looking at the index on the team dashboard.
      assert_text("Some New Example Site")
      assert_text("http://example.org/test")
      click_on "Some New Example Site"

      assert_text("Test Pages")
      click_on "Add New Test Page"

      assert_text("New Test Page Details")
      fill_in "Name", with: "Some New Example Site"
      fill_in "Path", with: "/test"
      click_on "Create Test Page"

      assert_text("Some New Example Site")
      assert_text("/test")
    end
  end
end
