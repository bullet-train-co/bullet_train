require "application_system_test_case"

class BulletTrain::SuperScaffolding::TestSiteTest < ApplicationSystemTestCase
  setup do
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
  #   rails test test/system/super_scaffolding/super_scaffolding_test.rb
  # to run the super scaffolding test suite as a whole:
  #   rails test test/system/super_scaffolding/
  #
  # after the test you can tear down what we've done here in the db:
  #   rake db:migrate VERSION=`ls db/migrate | sort | tail -n 9 | head -n 1`
  #   git checkout .
  #   git clean -d -f

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

      # this is ensuring cascading deletes generate properly.
      accept_alert do
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