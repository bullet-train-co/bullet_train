require "application_system_test_case"

class BulletTrain::SuperScaffolding::ProjectsStepTest < ApplicationSystemTestCase
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
