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

      assert page.has_content?("Upload New Document")
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
