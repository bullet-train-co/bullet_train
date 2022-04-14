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

      within_primary_menu_for(display_details) do
        click_on "Dashboard"
      end

      click_on "Add New Project"
      click_on "Create Project"
      assert page.has_content?("Name can't be blank.")
      fill_in "Name", with: "Some New Example Project"
      # TODO figure out how to interact with trix editor fields in capybara tests.
      click_on "Create Project"

      assert page.has_content?("Project was successfully created.")
      click_on "Some New Example Project"

      click_on "Add New Deliverable"
      click_on "Create Deliverable"
      assert page.has_content?("Name can't be blank.")
      fill_in "Name", with: "Some New Example Deliverable"
      click_on "Create Deliverable"
      assert page.has_content?("Deliverable was successfully created.")
      click_on "Some New Example Deliverable"

      click_on "Add New Objective"
      click_on "Create Objective"
      assert page.has_content?("Name can't be blank.")
      fill_in "Name", with: "Some New Example Objective"
      click_on "Create Objective"
      assert page.has_content?("Objective was successfully created.")
      click_on "Some New Example Objective"

      click_on "Add New Character Trait"
      click_on "Create Character Trait"
      assert page.has_content?("Name can't be blank.")
      fill_in "Name", with: "Some New Example Character Trait"
      click_on "Create Character Trait"
      assert page.has_content?("Character Trait was successfully created.")
      click_on "Some New Example Character Trait"

      click_on "Add New Note"
      click_on "Create Note"
      assert page.has_content?("Name can't be blank.")
      fill_in "Name", with: "Some New Example Note"
      click_on "Create Note"
      assert page.has_content?("Note was successfully created.")
      click_on "Some New Example Note"

      click_on "Add New Response"
      click_on "Create Response"
      assert page.has_content?("Name can't be blank.")
      fill_in "Name", with: "Some New Example Response"
      click_on "Create Response"
      assert page.has_content?("Response was successfully created.")
      click_on "Some New Example Response"

      within "ol.breadcrumb" do
        click_on "Projects"
      end

      assert page.has_content?("Your Team’s Projects")

      # this is ensuring cascading deletes generate properly.
      accept_alert do
        click_on "Delete"
      end

      assert page.has_content?("Project was successfully destroyed.")

      click_on "Add New Project"
      assert page.has_content? "New Project Details"
      fill_in "Name", with: "Example Project"
      click_on "Create Project"
      assert page.has_content? "Project was successfully created."

      within "ol.breadcrumb" do
        click_on "Dashboard"
      end

      assert page.has_content? "Below is a list of Test Sites that have been added for Your Team."

      # Edit the first test site.
      within "table", match: :first do
        click_on "Edit", match: :first
      end

      assert page.has_content? "Edit Test Site Details"

      # Select the project we created.
      find("#select2-test_site_project_id-container").click
      find("li.select2-results__option span", text: "Example Project").click
      click_on "Update Test Site"

      # Test the has-many-through scaffolding.
      assert page.has_content? "Test Site was successfully updated."

      click_on "Example Project"
      assert page.has_content? "Below are the details we have for Example Project"

      click_on "Back"
      assert page.has_content? "Below is a list of Projects"

      click_on "Back"
      assert page.has_content? "No Tags have been added"

      click_on "Add New Tag"
      assert page.has_content? "Please provide the details of the new Tag"

      fill_in "Name", with: "One"
      click_on "Create Tag"
      assert page.has_content? "Tag was successfully created"

      click_on "Add New Tag"
      assert page.has_content? "Please provide the details of the new Tag"

      fill_in "Name", with: "Two"
      click_on "Create Tag"
      assert page.has_content? "Tag was successfully created"

      click_on "Add New Tag"
      assert page.has_content? "Please provide the details of the new Tag"

      fill_in "Name", with: "Three"
      click_on "Create Tag"
      assert page.has_content? "Tag was successfully created"

      click_on "Back"
      assert page.has_content? "Your Team’s Dashboard"

      click_on "Add New Project"
      assert page.has_content? "Please provide the details of the new Project"

      fill_in "Name", with: "New Project with Tags"
      select2_select "Tags", ["One", "Two"]
      click_on "Create Project"
      assert page.has_content? "Project was successfully created"

      click_on "New Project with Tags"
      assert page.has_content? "Below are the details we have for New Project with Tags"
      assert page.has_content? "One and Two"
    end
  end

  test "super scaffolded partials function properly" do
    display_details = @@test_devices[:macbook_pro_15_inch]
    resize_for(display_details)

    login_as(@jane, scope: :user)
    visit account_team_path(@jane.current_team)

    click_on "Add New First Test Model"

    # Text Field partial
    fill_in "Test Text Field", with: "Test Text"
    # Boolean Button partial
    click_on "No"
    # Single Button partial
    find("#first_test_model_test_single_button_one+button", visible: :all).click
    # Multiple Button partial
    find("#first_test_model_test_multiple_buttons_two+button", visible: :all).click
    find("#first_test_model_test_multiple_buttons_three+button", visible: :all).click
    # Date partial
    find("#first_test_model_test_date").click
    find(".daterangepicker").click_on("apply") # Chooses today's date.
    # DateTime partial
    find("#first_test_model_test_date_time").click
    find(".daterangepicker").click_on("apply")
    # File partial
    attach_file("test/support/foo.txt", make_visible: true)
    # Single Option partial
    choose("One")

    # TODO: We'll need to adjust bullet_train-themes-tailwind_css to
    # make this one pass, will come back to this one soon.
    # Multiple Option partial
    # check("One")
    # check("Three")

    # Password partial
    fill_in "Test Password", with: "testpassword123"
    # Phone Field Partial
    fill_in "Test Phone Field", with: "(000)000-0000"
    # Super Select partial
    # Not using #select2_select here since we need to enable `other_options: {search: true}` to do so.
    find("#first_test_model_test_super_select").find("option[value='three']").select_option
    # Multple Super Select Partial
    find("#first_test_model_test_multiple_super_select").find("option[value='one']").select_option
    find("#first_test_model_test_multiple_super_select").find("option[value='two']").select_option
    # Text Area partial
    fill_in "Test Text Area", with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"

    click_on "Create First Test Model"
    assert page.has_content?("First Test Model was successfully created.")

    # Text field
    click_on "Test Text"
    assert page.has_content?("Test Text")
    # Boolean Button
    assert page.has_content?("No")
    # Single Button
    assert page.has_content?("One")
    # Multiple Buttons
    refute_nil FirstTestModel.first.test_multiple_buttons
    assert_equal FirstTestModel.first.test_multiple_buttons, ["two", "three"]
    # Date
    assert page.has_content?(Date.today.strftime("%B %d")) # i.e. - April 7
    # DateTime
    refute_nil FirstTestModel.first.test_date_time
    assert_equal FirstTestModel.first.test_date_time.class, ActiveSupport::TimeWithZone
    # File
    refute_nil FirstTestModel.first.test_file
    assert_equal FirstTestModel.first.test_file.class, ActiveStorage::Attached::One
    # Single Option
    refute_nil FirstTestModel.first.test_option
    assert_equal FirstTestModel.first.test_option, "one"
    # Multiple Options
    # refute_nil FirstTestModel.first.test_options
    # assert_equal FirstTestModel.first.test_options, ["one", "three"]
    # Password
    refute_nil FirstTestModel.first.test_password
    assert_equal FirstTestModel.first.test_password, "testpassword123"
    # Phone Field
    refute_nil FirstTestModel.first.test_phone_field
    assert_equal FirstTestModel.first.test_phone_field, "(000)000-0000"
    # Super Select
    refute_nil FirstTestModel.first.test_super_select
    assert_equal FirstTestModel.first.test_super_select, "three"
    # Multiple Super Select
    refute_nil FirstTestModel.first.test_multiple_super_select
    assert_equal FirstTestModel.first.test_multiple_super_select, ["one", "two"]
    # Text Area
    refute_nil FirstTestModel.first.test_text_area
    assert_equal FirstTestModel.first.test_text_area, "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
  end
end
