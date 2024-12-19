require "application_system_test_case"

class BulletTrain::SuperScaffolding::InsightTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

  # force autoload.
  [
    "Insight",
    "Personality::CharacterTrait"
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
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
end
