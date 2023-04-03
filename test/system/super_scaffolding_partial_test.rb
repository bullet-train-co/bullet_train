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
  #   rails test test/system/super_scaffolding_partial_test.rb
  #
  # after the test you can tear down what we've done here in the db:
  #   rake db:migrate VERSION=`ls db/migrate | sort | tail -n 9 | head -n 1`
  #   git checkout .
  #   git clean -d -f

  # force autoload.
  [
    "TestFile",
    "ColorPicker",
    "PartialTest"
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
  end

  if defined?(TestFile)
    test "developers can Super Scaffold a file partial and perfrom crud actions on the record" do
      display_details = @@test_devices[:macbook_pro_15_inch]
      resize_for(display_details)

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      assert page.has_content?("Test Files")
      click_on "Add New Test File"

      fill_in "Name", with: "Test File Name"
      assert page.has_content?("Upload New Document")
      fill_in "Name", with: "Foo"
      attach_file("test/support/foo.txt", make_visible: true)
      click_on "Create Test File"

      assert page.has_content?("Test File was successfully created.")
      refute TestFile.first.foo.blank?

      click_on "Edit"
      assert page.has_content?("Remove Current Document")
      find("span", text: "Remove Current Document").click
      click_on "Update Test File"

      assert page.has_content?("Test File was successfully updated.")
      assert TestFile.first.foo.blank?

      # This test consistently adds a new text file,
      # so we clear out all instances of foo from the storage directory.
      storage = Dir.glob("tmp/storage/**")
      storage.each { |dir| FileUtils.rm_r(dir) if dir.match?(/\/([0-9]|[a-z]){2}$/) }
    end
  end

  if defined?(ColorPicker)
    test "super scaffolded color pickers function properly" do
      display_details = @@test_devices[:macbook_pro_15_inch]
      resize_for(display_details)

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      assert page.has_content?("Add New Color Picker")
      click_on "Add New Color Picker"

      assert page.has_content?("Color Picker Value")
      color_picker_buttons = all(".button-color")
      assert_equal color_picker_buttons.size, 8
      color_picker_buttons.first.click
      click_on "Create Color Picker"

      assert page.has_content?("Color Picker was successfully created.")

      # The default value can be found in the color picker's locale.
      color_picker_default_value = "#9C73D2"
      assert_equal ColorPicker.first.color_picker_value, color_picker_default_value
      assert page.has_content?(color_picker_default_value)
    end
  end

  if defined?(PartialTest)
    test "super scaffolded partials function properly" do
      display_details = @@test_devices[:macbook_pro_15_inch]
      resize_for(display_details)

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Partial Test"

      # Text Field partial
      fill_in "Text Field Test", with: "Test Text"
      # Boolean Button partial
      choose "No"
      # Single Button partial
      find("#partial_test_single_button_test_one+button", visible: :all).click
      # Multiple Button partial
      find("#partial_test_multiple_buttons_test_two+button", visible: :all).click
      find("#partial_test_multiple_buttons_test_three+button", visible: :all).click
      # Date partial
      find("#partial_test_date_test").click
      find(".daterangepicker").click_on("Apply") # Chooses today's date.
      # DateTime partial
      find("#partial_test_date_time_test").click
      find(".daterangepicker").click_on("Apply")
      # File partial
      attach_file("test/support/foo.txt", make_visible: true)
      # Single Option partial
      choose("One")
      # Multiple Option partial
      check("One")
      check("Three")
      # Password partial
      # fill_in "Password Test", with: "testpassword123"
      # Phone Field Partial
      fill_in "Phone Field Test", with: "(000)000-0000"
      # Super Select partial
      # Not using #select2_select here since we need to enable `other_options: {search: true}` to do so.
      find("#partial_test_super_select_test").find("option[value='three']").select_option
      # Multple Super Select Partial
      find("#partial_test_multiple_super_select_test").find("option[value='one']").select_option
      find("#partial_test_multiple_super_select_test").find("option[value='two']").select_option
      # Text Area partial
      fill_in "Text Area Test", with: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"

      click_on "Create Partial Test"
      assert page.has_content?("Partial Test was successfully created.")

      # Text field
      partial_test = PartialTest.first
      assert_equal partial_test.text_field_test, "Test Text"
      # Boolean Button
      assert_equal partial_test.boolean_test, false
      # Single Button
      assert_equal partial_test.single_button_test, "one"
      # Multiple Buttons
      refute_nil partial_test.multiple_buttons_test
      assert_equal partial_test.multiple_buttons_test, ["two", "three"]
      # Date
      assert_equal partial_test.date_test, Date.today
      # DateTime
      refute_nil partial_test.date_time_test
      assert_equal partial_test.date_time_test.class, ActiveSupport::TimeWithZone
      # File
      refute_nil partial_test.file_test
      assert_equal partial_test.file_test.class, ActiveStorage::Attached::One
      # Single Option
      refute_nil partial_test.option_test
      assert_equal partial_test.option_test, "one"
      # Multiple Options
      refute_nil partial_test.multiple_options_test
      assert_equal partial_test.multiple_options_test, ["one", "three"]
      # Password
      # refute_nil partial_test.password_test
      # assert_equal partial_test.password_test, "testpassword123"
      # Phone Field
      refute_nil partial_test.phone_field_test
      assert_equal partial_test.phone_field_test, "(000)000-0000"
      # Super Select
      refute_nil partial_test.super_select_test
      assert_equal partial_test.super_select_test, "three"
      # Multiple Super Select
      refute_nil partial_test.multiple_super_select_test
      assert_equal partial_test.multiple_super_select_test, ["one", "two"]
      # Text Area
      refute_nil partial_test.text_area_test
      assert_equal partial_test.text_area_test, "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    end
  end
end
