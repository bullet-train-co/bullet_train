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
  begin
    TestFile
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

  if defined?(PartialTest)
    test "developers can pass custom format to date and date_and_time partials" do
      display_details = @@test_devices[:macbook_pro_15_inch]
      resize_for(display_details)

      login_as(@jane, scope: :user)
      visit account_team_path(@jane.current_team)

      click_on "Add New Partial Test"

      find("#partial_test_date_test").click
      find(".daterangepicker").click_on("apply") # Chooses today's date.

      # We should be able to create a new record without passing any format options.
      click_on "Create Partial Test"
      assert page.has_content?("Partial Test was successfully created.")
      assert page.has_content?(Date.today.strftime("%B %-d"))

      # Edit the index partial.
      custom_date_format = "\"%m/%d\"" # i.e. - 04/07 for April 4th
      custom_time_format = "\"%I %p\"" # i.e. - 11 P.M. (cuts off the minutes)

      file_path = "#{Rails.root}/app/views/account/partial_tests/_index.html.erb"
      transformed_content = []
      File.open(file_path, "r") do |file|
        original_content = file.readlines

        # For these regular expressions, we take the space at the end of the embedded ruby and replace it with our option.
        transformed_content = original_content.map do |line|
          if line.match?(/attribute: :date_test/)
            line.gsub(/(.*url: \[:account, partial_test\])(\s)(%><\/td>\n$)/, '\1' + ", date_format: #{custom_date_format} " + '\3')
          elsif line.match?(/attribute: :created_at/)
            line.gsub(/(.*:created_at)(\s)(%><\/td>\n$)/, '\1' + ", date_format: #{custom_date_format}, time_format: #{custom_time_format} " + '\3')
          else
            line
          end
        end
      end

      File.write(file_path, transformed_content.join(""))

      # Should show properly on the index partial.
      visit account_team_partial_tests_path(@jane.current_team)

      # TODO: The system test isn't reflect the changes to the index partial made above.
      # assert page.has_content?(Date.today.strftime("%m/%d"))
      # assert page.has_content?(Time.now.strftime("%H %p"))
    end
  end
end
