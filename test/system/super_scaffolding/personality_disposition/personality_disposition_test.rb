require "application_system_test_case"

class BulletTrain::SuperScaffolding::PersonalityDispositionTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

  # force autoload.
  [
    "Personality::Disposition",
    "Personality::Note",
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
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
end
