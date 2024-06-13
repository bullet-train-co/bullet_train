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
    "Projects::ArchiveAction",
    "Listings::PublishAction",
    "Notifications::MarkAllAsReadAction",
    "Articles::CsvImportAction",
    "Visitors::CsvExportAction"
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
  end

  # targets-many action
  if defined?(Projects::ArchiveAction)
    # This error message is displayed for all actions, not just `targets-many`.
    test "the proper error message is displayed for unneeded namespaces" do
      output = `rails g super_scaffold:action_models:targets_many Project::Publish Project Team`
      assert output.include?("When creating an Action Model, you don't have to namespace the action")
    end

    test "developers can archive a single project" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Project"
      fill_in "Name", with: "Test Project"
      click_on "Create Project"
      click_on "Back"
      click_on "Add New Project"
      fill_in "Name", with: "Another Test Project"
      click_on "Create Project"

      # Test targets-many logic
      click_on "Back"
      click_on "Select Multiple"
      check "Test Project"
      click_on "Archive (1)"

      # Confirm action page
      assert_text("We're preparing to Archive 1 Project of Your Team")
      click_on "Perform Archive Action"

      assert_text("Archive Action was successfully created.")
      assert_text(/Processed 1 of 1 Today/i)
    end

    test "developers can archive multiple projects at once" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      3.times do |n|
        click_on "Add New Project"
        fill_in "Name", with: "Project #{n}"
        click_on "Create Project"
        assert_text "Project was successfully created."
        click_on "Back"
      end

      # Test targets-many logic
      click_on "Select Multiple"
      check "Project 1"
      check "Project 2"
      click_on "Archive (2)"

      # Confirm action page
      assert_text("We're preparing to Archive 2 Projects of Your Team.")
      click_on "Perform Archive Action"

      assert_text("Archive Action was successfully created.")
      assert_text("Archive Action on 2 Projects")
      assert_text(/Processed 2 of 2 Today/i)
    end
  end

  # targets-one action
  if defined?(Listings::PublishAction)
    test "developers can publish only one listing at a time" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Listing"
      fill_in "Name", with: "Test Listing"
      click_on "Create Listing"
      click_on "Back"

      # TODO: The following section of this test seems to be invalid as written.
      # Once clicking on the "Back" link there is no "Publish" text on the listings/index page.
      # Sometimes that check passes because capybara evaluates the state of the page _before_
      # the click aciton succeeds. I don't find "Select Multiple" being available anywhere within
      # the listings heirarchy of pages. Someone who knows more about the action models gem probably
      # needs to rewrite the remainder of this section of the test to be a valid scenario.

      # Developers can click "Publish" on a single record,
      # but cannot perform the action on multiple ones.
      #
      # assert_text("Publish")
      # click_on "Select Multiple"
      # refute_text("Publish")
      # click_on "Hide Checkboxes"
      # click_on "Back"

      # TODO: End invalid test section

      # Test targets-one logic
      click_on "Test Listing"
      click_on "Publish"

      # Confirm action page
      assert_text("Please provide the details of the new Publish Action you'd like to perform on Test Listing.")
      click_on "Perform Publish Action"

      assert_text("Publish Action was successfully created.")
      assert_text("Current and Scheduled Publish Operations")
    end
  end

  # targets-one-parent action
  if defined?(Notifications::MarkAllAsReadAction)
    test "developers can mark as read all notifications of a customer" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      3.times do |n|
        click_on "Add New Customer"
        fill_in "Name", with: "Test Customer #{n}"
        click_on "Create Customer"
        assert_text "Customer was successfully created."

        3.times do |i|
          click_on "Add New Notification"
          fill_in "Text", with: "Test Notification #{i}"
          click_on "Create Notification"
          assert_text "Notification was successfully created."
          click_on "Back"
        end

        # TODO: "Back" button didn't work here
        click_on "Customers"
      end

      click_on "Test Customer 1"

      # Developers can click "Mark All As Read" on a multiple records.
      assert_text("Mark All As Read")
      click_on "Mark All As Read"

      # Confirm action page
      click_on "Perform Mark All As Read Action"

      assert_text("Mark All As Read Action was successfully created.")
    end
  end

  # performs-import action
  if defined?(Articles::CsvImportAction)
    test "developers can import CSV file information to their records" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)
      assert_text "No Articles have been added for Your Team."

      click_on "Csv Import"
      assert_text "Csv Import Articles"

      attach_file("test/support/articles.csv", make_visible: true)
      click_on "Configure Csv Import Action"

      assert_text "Csv Import Action was successfully created."
      click_on "Preview Csv Import Action"

      assert_text "Csv Import Action was successfully updated."
      click_on "Perform Csv Import Action"

      assert_text "Csv Import Action was approved."
      click_on "Back"

      assert_text "Below is a list of Articles that have been added for Your Team."
      assert_text "Three"
      # We do this because the default Bullet Train team stylizes this text in capital letters.
      assert_match(/processed 3 of 3/i, page.text)
      assert_text "articles.csv"
    end
  end

  # performs-export action
  if defined?(Visitors::CsvExportAction)
    test "developers can export a CSV file from their records" do
      @jane.current_team.visitors.create(email: "one@example.com", first_name: "Liam", last_name: "Patel")
      @jane.current_team.visitors.create(email: "two@example.com", first_name: "Ava", last_name: "Brown")
      @jane.current_team.visitors.create(email: "three@example.com", first_name: "Ethan", last_name: "Kim")
      250.times do
        @jane.current_team.visitors.create(email: "random+#{SecureRandom.uuid}@example.com", first_name: SecureRandom.hex.first(5), last_name: SecureRandom.hex.first(5))
      end

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "one@example.com"
      assert_text "Below are the details we have for one@example.com"
      click_on "Back"

      click_on "Select Multiple"
      find(:xpath, "/HTML[1]/BODY[1]/DIV[2]/DIV[1]/DIV[2]/MAIN[1]/DIV[2]/DIV[1]/DIV[3]/DIV[1]/CABLE-READY-UPDATES-FOR[1]/DIV[1]/DIV[2]/DIV[1]/TABLE[1]/THEAD[1]/TR[1]/TH[1]/LABEL[1]/INPUT[1]").click
      click_on "Csv Export (All)"
      assert_text "We're preparing to Export all Visitors of Your Team."

      click_on "Perform Csv Export Action"
      assert_text "Csv Export Action was successfully created."

      # This is a lot easier than trying to actually download the file via the browser.
      csv_export_action = Visitors::CsvExportAction.order(:id).last
      csv_data = csv_export_action.file.download

      # Ensure the header is in the right spot.
      assert_match(/id,email,first_name,last_name/, csv_data.lines.first)

      # Ensure the first record is where we expect it.
      assert_match(/one@example.com,Liam,Patel/, csv_data.lines[1])

      # Ensure the other records are in the CSV.
      assert_match(/two@example.com,Ava,Brown/, csv_data)
      assert_match(/three@example.com,Ethan,Kim/, csv_data)

      # Ensure all records and headers were exported.
      assert_equal csv_data.lines.count, 254
    end
  end
end
