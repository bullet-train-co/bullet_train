require "application_system_test_case"

class SuperScaffoldingSystemTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: the setup for this test really requires a clean git workspace.
  # you'll see why toward the end when you're trying to clean up the files
  # created (and then afterwards tested in the test below.)
  #
  # before this test can be run, we need to do the following setup on the console:
  #   bundle exec test/bin/setup-super-scaffolding-system-test
  #
  # to run this test:
  #   rails test test/system/super_scaffolding_test.rb
  #
  # after the test you can tear down what we've done here in the db:
  #   rake db:migrate VERSION=`ls db/migrate | sort | tail -n 9 | head -n 1`
  #   git checkout .
  #   git clean -d -f

  # force autoload.
  begin
    TestSite
  rescue
    nil
  end
  begin
    TestPage
  rescue
    nil
  end

  if defined?(TestSite) && defined?(TestPage)

    test "developers can generate a site and a nested page model" do
      display_details = @@test_devices[:macbook_pro_15_inch]
      resize_for(display_details)

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      assert page.has_content?("Test Sites")
      click_on "Add New Test Site"

      assert page.has_content?("New Test Site Details")
      fill_in "Name", with: "Some New Example Site"
      fill_in "Other Attribute", with: "Some Other Value"
      fill_in "Url", with: "http://example.org/test"
      click_on "Create Test Site"

      # make sure the content is being displayed on the index partial.
      assert page.has_content?("Some New Example Site")
      assert page.has_content?("http://example.org/test")

      # we're now looking at the index on the team dashboard.
      click_on "Some New Example Site"
      assert page.has_content?("Test Site Details")
      assert page.has_content?("Some New Example Site")
      assert page.has_content?("http://example.org/test")

      assert page.has_content?("Test Pages")
      click_on "Add New Test Page"

      assert page.has_content?("New Test Page Details")
      fill_in "Name", with: "Some New Example Site"
      fill_in "Path", with: "/test"
      click_on "Create Test Page"

      assert page.has_content?("Some New Example Site")
      assert page.has_content?("/test")

      # within_primary_menu_for(display_details) do
      #   click_on "Dashboard"
      # end

      # click_on "Add New Project"
      # click_on "Create Project"
      # assert page.has_content?("Name can't be blank.")
      # fill_in "Name", with: "Some New Example Project"
      # # TODO figure out how to interact with trix editor fields in capybara tests.
      # click_on "Create Project"

      # assert page.has_content?("Project was successfully created.")
      # click_on "Some New Example Project"

      # click_on "Add New Deliverable"
      # click_on "Create Deliverable"
      # assert page.has_content?("Name can't be blank.")
      # fill_in "Name", with: "Some New Example Deliverable"
      # click_on "Create Deliverable"
      # assert page.has_content?("Deliverable was successfully created.")
      # click_on "Some New Example Deliverable"

      # click_on "Add New Objective"
      # click_on "Create Objective"
      # assert page.has_content?("Name can't be blank.")
      # fill_in "Name", with: "Some New Example Objective"
      # click_on "Create Objective"
      # assert page.has_content?("Objective was successfully created.")
      # click_on "Some New Example Objective"

      # click_on "Add New Character Trait"
      # click_on "Create Character Trait"
      # assert page.has_content?("Name can't be blank.")
      # fill_in "Name", with: "Some New Example Character Trait"
      # click_on "Create Character Trait"
      # assert page.has_content?("Character Trait was successfully created.")
      # click_on "Some New Example Character Trait"

      # click_on "Add New Note"
      # click_on "Create Note"
      # assert page.has_content?("Name can't be blank.")
      # fill_in "Name", with: "Some New Example Note"
      # click_on "Create Note"
      # assert page.has_content?("Note was successfully created.")
      # click_on "Some New Example Note"

      # click_on "Add New Response"
      # click_on "Create Response"
      # assert page.has_content?("Name can't be blank.")
      # fill_in "Name", with: "Some New Example Response"
      # click_on "Create Response"
      # assert page.has_content?("Response was successfully created.")
      # click_on "Some New Example Response"

      # within "ol.breadcrumb" do
      #   click_on "Projects"
      # end

      # assert page.has_content?("Your Team’s Projects")

      # # this is ensuring cascading deletes generate properly.
      # accept_alert do
      #   click_on "Delete"
      # end

      # assert page.has_content?("Project was successfully destroyed.")

      # click_on "Add New Project"
      # assert page.has_content? "New Project Details"
      # fill_in "Name", with: "Example Project"
      # click_on "Create Project"
      # assert page.has_content? "Project was successfully created."

      # within "ol.breadcrumb" do
      #   click_on "Dashboard"
      # end

      # assert page.has_content? "Below is a list of Test Sites that have been added for Your Team."

      # # Edit the first test site.
      # within "table", match: :first do
      #   click_on "Edit", match: :first
      # end

      # assert page.has_content? "Edit Test Site Details"

      # # Select the project we created.
      # find("#select2-test_site_project_id-container").click
      # find("li.select2-results__option span", text: "Example Project").click
      # click_on "Update Test Site"

      # # Test the has-many-through scaffolding.
      # assert page.has_content? "Test Site was successfully updated."

      # click_on "Example Project"
      # assert page.has_content? "Below are the details we have for Example Project"

      # click_on "Back"
      # assert page.has_content? "Below is a list of Projects"

      # click_on "Back"
      # assert page.has_content? "No Tags have been added"

      # click_on "Add New Tag"
      # assert page.has_content? "Please provide the details of the new Tag"

      # fill_in "Name", with: "One"
      # click_on "Create Tag"
      # assert page.has_content? "Tag was successfully created"

      # click_on "Add New Tag"
      # assert page.has_content? "Please provide the details of the new Tag"

      # fill_in "Name", with: "Two"
      # click_on "Create Tag"
      # assert page.has_content? "Tag was successfully created"

      # click_on "Add New Tag"
      # assert page.has_content? "Please provide the details of the new Tag"

      # fill_in "Name", with: "Three"
      # click_on "Create Tag"
      # assert page.has_content? "Tag was successfully created"

      # click_on "Back"
      # assert page.has_content? "Your Team’s Dashboard"

      # click_on "Add New Project"
      # assert page.has_content? "Please provide the details of the new Project"

      # fill_in "Name", with: "New Project with Tags"
      # select2_select "Tags", ["One", "Two"]
      # click_on "Create Project"
      # assert page.has_content? "Project was successfully created"

      # click_on "New Project with Tags"
      # assert page.has_content? "Below are the details we have for New Project with Tags"
      # assert page.has_content? "One and Two"
    end
  end
end
