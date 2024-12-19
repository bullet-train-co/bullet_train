require "application_system_test_case"

class BulletTrain::SuperScaffolding::TestFileTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

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
    device_test "developers can Super Scaffold a file partial and perform crud actions on the record" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      assert_text("Test Files")
      click_on "Add New Test File"

      fill_in "Name", with: "Test File Name"
      assert_text("Upload New File")
      fill_in "Name", with: "Foo"
      attach_file("Foo", "test/support/foo.txt", make_visible: true)
      attach_file("Bars", ["test/support/foo.txt", "test/support/foo-two.txt"], make_visible: true)
      click_on "Create Test File"

      assert_text("Test File was successfully created.")
      refute TestFile.first.foo.blank?
      assert_equal 2, TestFile.first.bars.count

      click_on "Edit"

      assert_text("Remove Current File")
      within "[data-fields--file-item-id-value='#{TestFile.first.foo.id}']" do
        find("span", text: "Remove Current File").click
      end
      click_on "Update Test File"

      assert_text("Test File was successfully updated.")
      assert TestFile.first.foo.blank?

      click_on "Edit"
      assert_text("Remove Current File")
      within "[data-fields--file-item-id-value='#{TestFile.first.bars.first.id}']" do
        find("span", text: "Remove Current File").click
      end
      click_on "Update Test File"

      assert_text("Test File was successfully updated.")
      assert_equal 1, TestFile.first.bars.count

      # This test consistently adds several new text files,
      # so we clear out all instances of foo from the storage directory.
      storage = Dir.glob("tmp/storage/**")
      storage.each { |dir| FileUtils.rm_r(dir) if dir.match?(/\/([0-9]|[a-z]){2}$/) }
    end
  end

  if defined?(ColorPicker)
    device_test "super scaffolded color pickers function properly" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      assert_text("Add New Color Picker")
      click_on "Add New Color Picker"

      assert_text("Color Picker Value")
      color_picker_buttons = all(".button-color")
      assert_equal color_picker_buttons.size, 8
      color_picker_buttons.first.click
      click_on "Create Color Picker"

      assert_text("Color Picker was successfully created.")

      # The default value can be found in the color picker's locale.
      color_picker_default_value = "#9C73D2"
      assert_equal ColorPicker.first.color_picker_value, color_picker_default_value
      assert_text(color_picker_default_value)
    end
  end
end
