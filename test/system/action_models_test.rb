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
    "Articles::CsvImportAction"
  ].each do |class_name|
    class_name.constantize
  rescue
    nil
  end

  # targets-many action
  if defined?(Projects::ArchiveAction)
    test "developers can archive a single project" do
      skip "This needs to be fixed in Action Models first"

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Project"
      fill_in "Name", with: "Test Project"
      click_on "Create Project"

      # Test targets-many logic
      click_on "Archive"

      # Confirm action page
      # TODO: `Projects` shouldn't be plural here.
      assert page.has_content?("We're preparing to Archive 1 Projects of Your Team")
      click_on "Perform Archive Action"

      assert page.has_content?("Archive Action was successfully created.")
      assert page.has_content?("Test Project archived")
      assert page.has_content?(/Processed 1 of 1 Today/i)
    end

    test "developers can archive multiple projects at once" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      3.times do |n|
        click_on "Add New Project"
        fill_in "Name", with: "Project #{n}"
        click_on "Create Project"
        assert page.has_content? "Project was successfully created."
        click_on "Back"
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

  # targets-one action
  if defined?(Listings::PublishAction)
    test "developers can publish only one listing at a time" do
      skip "This needs to be fixed in Action Models first"

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Listing"
      fill_in "Name", with: "Test Listing"
      click_on "Create Listing"

      # Developers can click "Publish" on a single record,
      # but cannot perform the action on multiple ones.
      assert page.has_content?("Publish")
      click_on "Select Multiple"
      refute page.has_content?("Publish")
      click_on "Hide Checkboxes"

      # Test targets-one logic
      click_on "Publish"

      # Confirm action page
      assert page.has_content?("Please provide the details of the new Publish Action you'd like to add to Test Listing.")
      click_on "Perform Publish Action"

      assert page.has_content?("Test Listing published")
      assert page.has_content?("Publish Action was successfully created.")
      assert page.has_content?("Current and Scheduled Publish Operations")
    end
  end

  # performs-import action
  if defined?(Articles::CsvImportAction)
    test "developers can import CSV file information to their records" do
      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)
      assert page.has_content? "No Articles have been added for Your Team."

      click_on "Csv Import"
      assert page.has_content? "Csv Import Articles"

      attach_file("test/support/articles.csv", make_visible: true)
      click_on "Configure Csv Import Action"

      assert page.has_content? "Csv Import Action was successfully created."
      click_on "Preview Csv Import Action"

      assert page.has_content? "Csv Import Action was successfully updated."
      click_on "Perform Csv Import Action"

      assert page.has_content? "Csv Import Action was approved."
      click_on "Back"

      assert page.has_content? "Below is a list of Articles that have been added for Your Team."
      assert page.has_content? "Three"
      # We do this because the default Bullet Train team stylizes this text in capital letters.
      assert_match(/processed 3 of 3/i, page.text)
      assert page.has_content? "articles.csv"
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
      assert page.has_content? "Below are the details we have for one@example.com"
      click_on "Back"

      click_on "Select Multiple"
      find(:xpath, "/HTML[1]/BODY[1]/DIV[2]/DIV[1]/DIV[2]/MAIN[1]/DIV[2]/DIV[1]/DIV[3]/DIV[1]/UPDATES-FOR[1]/DIV[1]/DIV[2]/DIV[1]/TABLE[1]/THEAD[1]/TR[1]/TH[1]/LABEL[1]/INPUT[1]").click
      click_on "Csv Export (All)"
      assert page.has_content? "We're preparing to Export all Visitors of Your Team."

      click_on "Perform Csv Export Action"
      assert page.has_content? "Csv Export Action was successfully created."

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
