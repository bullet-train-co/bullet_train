require "application_system_test_case"

class BulletTrain::SuperScaffolding::ProjectTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

  # force autoload.
  [
    "Projects::Deliverable",
    "Projects::Tag",
    "Projects::AppliedTag",
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
  end

  if defined?(Project)
    test "developers can generate a Project and a nested Projects::Deliverable model" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Project"
      click_on "Create Project"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Project"
      click_on "Create Project"

      assert_text("Project was successfully created.")

      click_on "Add New Deliverable"
      click_on "Create Deliverable"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Deliverable"
      click_on "Create Deliverable"
      assert_text("Deliverable was successfully created.")

      within "ol.breadcrumb" do
        click_on "Projects"
      end

      assert_text("Your Team’s Projects")

      # will this help?
      sleep 1
      # this is ensuring cascading deletes generate properly.
      accept_confirm do
        click_on "Delete"
      end

      assert_text("Project was successfully destroyed.")

      click_on "Add New Project"
      assert_text "New Project Details"
      fill_in "Name", with: "Example Project"
      click_on "Create Project"
      assert_text "Project was successfully created."

      within "ol.breadcrumb" do
        click_on "Dashboard"
      end

      click_on "Example Project"
      assert_text "Below are the details we have for Example Project"

      click_on "Back"
      assert_text "Below is a list of Projects"

      click_on "Back"
      assert_text "No Tags have been added"

      click_on "Add New Tag"
      assert_text "Please provide the details of the new Tag"

      fill_in "Name", with: "One"
      click_on "Create Tag"
      assert_text "Tag was successfully created"

      click_on "Back"

      click_on "Add New Tag"
      assert_text "Please provide the details of the new Tag"

      fill_in "Name", with: "Two"
      click_on "Create Tag"
      assert_text "Tag was successfully created"

      click_on "Back"

      click_on "Add New Tag"
      assert_text "Please provide the details of the new Tag"

      fill_in "Name", with: "Three"
      click_on "Create Tag"
      assert_text "Tag was successfully created"

      click_on "Back"
      assert_text "Your Team’s Tags"
      click_on "Back"
      assert_text "Your Team’s Dashboard"

      click_on "Add New Project"
      assert_text "Please provide the details of the new Project"

      fill_in "Name", with: "New Project with Tags"
      select2_select "Tags", ["One", "Two"]
      click_on "Create Project"
      assert_text "Project was successfully created"

      assert_text "Below are the details we have for New Project with Tags"
      assert_text "One and Two"
    end
  end
end
