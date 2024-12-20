require "application_system_test_case"

class BulletTrain::SuperScaffolding::ProjectsStepTest < ApplicationSystemTestCase
  setup do
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: This test only runs if the `setup.rb` file in this directory has run.
  # See ../README.md for details.

  # force autoload.
  [
    "Projects::Step",
    "Objective",
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
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
end
