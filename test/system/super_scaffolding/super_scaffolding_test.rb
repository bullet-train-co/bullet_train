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
    "TestSite",
    "TestPage",
    "Project",
    "Projects::Deliverable",
    "Projects::Tag",
    "Projects::AppliedTag",
    "Projects::Step",
    "Objective",
    "Insight",
    "Personality::CharacterTrait",
    "Personality::Disposition",
    "Personality::Note",
    "Personality::Observation",
    "Personality::Reactions::Response",
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

  if defined?(Projects::Step)
    test "developers can generate a Projects::Step and a nested Objective model" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Step"
      click_on "Create Step"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Step"
      click_on "Create Step"

      assert_text("Step was successfully created.")

      click_on "Add New Objective"
      click_on "Create Objective"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Objective"
      click_on "Create Objective"
      assert_text("Objective was successfully created.")
    end
  end

  if defined?(Insight)
    test "developers can generate a Insight and a nested Personality::CharacterTrait model" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Insight"
      click_on "Create Insight"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Insight"
      click_on "Create Insight"

      assert_text("Insight was successfully created.")

      click_on "Add New Character Trait"
      click_on "Create Character Trait"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Character Trait"
      click_on "Create Character Trait"
      assert_text("Character Trait was successfully created.")
    end
  end

  if defined?(Personality::Disposition)
    test "developers can generate a Personality::Disposition and a nested Personality::Note model" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Disposition"
      click_on "Create Disposition"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Disposition"
      click_on "Create Disposition"

      assert_text("Disposition was successfully created.")

      click_on "Add New Note"
      click_on "Create Note"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Note"
      click_on "Create Note"
      assert_text("Note was successfully created.")
    end
  end

  if defined?(Personality::Observation)
    test "developers can generate a Personality::Observation and a nested Personality::Reactions::Response model" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Observation"
      click_on "Create Observation"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Observation"
      click_on "Create Observation"

      assert_text("Observation was successfully created.")

      click_on "Add New Response"
      click_on "Create Response"
      assert_text("Name can't be blank.")
      fill_in "Name", with: "Some New Example Response"
      click_on "Create Response"
      assert_text("Response was successfully created.")
    end
  end

  test "OpenAPI V3 document is still valid" do
    visit "/" # Make sure the test server is running before linting the file.
    puts(output = `yarn exec redocly lint http://127.0.0.1:3001/api/v1/openapi.yaml 1> /dev/stdout 2> /dev/stdout`)
    # redocly/openapi-core changed the format of their success message in version 1.2.0.
    # https://github.com/Redocly/redocly-cli/pull/1239
    # We use a robust regex here so that we can match both formats.
    assert output.match?(/Woohoo! Your (Open)?API (definition|description) is valid./)
  end
end
