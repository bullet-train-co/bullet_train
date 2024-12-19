require "application_system_test_case"

class BulletTrain::SuperScaffolding::PersonalityObservationTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

  # force autoload.
  [
    "Personality::Observation",
    "Personality::Reactions::Response",
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
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
end
