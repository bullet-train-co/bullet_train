require 'test_helper'

class SuperScaffoldingSystemTest < ActionDispatch::IntegrationTest
  def setup
    super
    @jane = create :onboarded_user, first_name: 'Jane', last_name: 'Smith'
  end

  # NOTE: the setup for this test really requires a clean git workspace.
  # you'll see why toward the end when you're trying to clean up the files
  # created (and then afterwards tested in the test below.)
  #
  # before this test can be run, we need to do the following setup on the console:
  #   bundle exec test/bin/setup-super-scaffolding-system-test
  #
  # to run this test:
  #   rails test test/integration/super_scaffolding_system_test.rb
  #
  # after the test you can tear down what we've done here in the db:
  #   rake db:migrate VERSION=`ls db/migrate | sort | tail -n 3 | head -n 1`
  #   git checkout .
  #   git clean -d -f

  # force autoload.
  TestSite rescue nil
  TestPage rescue nil

  if defined?(TestSite) && defined?(TestPage)

    test "developers can generate a site and a nested page model" do
      resize_for(@@test_devices[:macbook_pro_15_inch])

      login_as(@jane, :scope => :user)
      visit account_team_path(@jane.current_team)

      assert page.has_content?("Test Sites")
      click_on 'Add New Test Site'

      assert page.has_content?("New Test Site Details")
      fill_in 'Name', with: 'Some New Example Site'
      fill_in 'Url', with: 'http://example.org/test'
      click_on 'Create Test Site'

      # make sure the content is being displayed on the index partial.
      assert page.has_content?("Some New Example Site")
      assert page.has_content?("http://example.org/test")

      # we're now looking at the index on the team dashboard.
      click_on 'Some New Example Site'
      assert page.has_content?("Test Site Details")
      assert page.has_content?("Some New Example Site")
      assert page.has_content?("http://example.org/test")

      assert page.has_content?("Test Pages")
      click_on 'Add New Test Page'

      assert page.has_content?("New Test Page Details")
      fill_in 'Name', with: 'Some New Example Site'
      fill_in 'Path', with: '/test'
      click_on 'Create Test Page'

      assert page.has_content?("Some New Example Site")
      assert page.has_content?("/test")

      within ".menu-w .main-menu" do
        click_on 'Dashboard'
      end

      click_on 'Add New Project'
      click_on 'Create Project'
      assert page.has_content?("Name can't be blank.")
      fill_in 'Name', with: 'Some New Example Project'
      # TODO figure out how to interact with trix editor fields in capybara tests.
      click_on 'Create Project'

      assert page.has_content?("Project was successfully created.")
      click_on 'Some New Example Project'

      click_on 'Add New Deliverable'
      click_on 'Create Deliverable'
      assert page.has_content?("Name can't be blank.")
      fill_in 'Name', with: 'Some New Example Deliverable'
      click_on 'Create Deliverable'
      assert page.has_content?("Deliverable was successfully created.")
      click_on 'Some New Example Deliverable'

      click_on 'Add New Objective'
      click_on 'Create Objective'
      assert page.has_content?("Name can't be blank.")
      fill_in 'Name', with: 'Some New Example Objective'
      click_on 'Create Objective'
      assert page.has_content?("Objective was successfully created.")
      click_on 'Some New Example Objective'

      click_on 'Add New Character Trait'
      click_on 'Create Character Trait'
      assert page.has_content?("Name can't be blank.")
      fill_in 'Name', with: 'Some New Example Character Trait'
      click_on 'Create Character Trait'
      assert page.has_content?("Character Trait was successfully created.")
      click_on 'Some New Example Character Trait'

      click_on 'Add New Note'
      click_on 'Create Note'
      assert page.has_content?("Name can't be blank.")
      fill_in 'Name', with: 'Some New Example Note'
      click_on 'Create Note'
      assert page.has_content?("Note was successfully created.")
      click_on 'Some New Example Note'

      click_on 'Add New Response'
      click_on 'Create Response'
      assert page.has_content?("Name can't be blank.")
      fill_in 'Name', with: 'Some New Example Response'
      click_on 'Create Response'
      assert page.has_content?("Response was successfully created.")
      click_on 'Some New Example Response'

      within "ol.breadcrumb" do
        click_on 'Projects'
      end

      assert page.has_content?('Your Team’s Projects')

      # this is ensuring cascading deletes generate properly.
      accept_alert do
        click_on 'Delete'
      end

      assert page.has_content?('Project was successfully destroyed.')
    end
  end
end
