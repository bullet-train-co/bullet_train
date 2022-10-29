# Action Models is a Bullet Train Pro option.
# If you are interested in using Action Models,
# please refer to the documentation: https://bullettrain.co/docs/action-models

require "application_system_test_case"

class ActionModelsSystemTest < ApplicationSystemTestCase
  def setup
    super
    @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
  end

  # NOTE: the setup for this test really requires a clean git workspace.
  # you'll see why toward the end when you're trying to clean up the files
  # created (and then afterwards tested in the test below.)
  #
  # before this test can be run, we need to do the following setup on the console:
  #   bundle exec test/bin/setup-action-models-system-test
  #
  # to run this test:
  #   rails test test/system/action_models_test.rb
  #
  # after the test you can tear down what we've done here in the db:
  #   rake db:migrate VERSION=`ls db/migrate | sort | tail -n 9 | head -n 1`
  #   git checkout .
  #   git clean -d -f

  # force autoload.
  [
    "Archive"
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
  end

  # 💡 All of the logic for the specific actions are written in the setup script.
  # Please edit that file if you want the action we're testing to do something else.

  if defined?(Projects::ArchiveAction)
    test "developers can archive a single project" do
      # TODO: Write this test.
    end

    test "developers can archive multiple projects at once" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      3.times do |n|
        click_on "Add New Project"
        fill_in "Name", with: "Project #{n}"
        click_on "Create Project"
      end

      # Test targets-many logic
      click_on "Select Multiple"
      check "Project 1"
      check "Project 2"
      click_on "Archive (2)"

      # Confirm action page
      assert page.has_content?("We're preparing to Archive 2 Projects of Your Team.")
      click_on "Perform Archive Action"

      assert page.has_content?("Archive Action was successfully created.")
      assert page.has_content?("Project 1 archived")
      assert page.has_content?("Project 2 archived")
      assert page.has_content?("Archive Action on 2 Projects")
      assert page.has_content?(/Processed 2 of 2 Today/i)
    end
  end
end
