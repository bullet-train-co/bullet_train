require "application_system_test_case"

module BulletTrainGems
  module AuditLogs
    class SuperScaffoldingSystemTest < ApplicationSystemTestCase
      def setup
        skip unless File.readlines("Gemfile").grep(/bullet_train-audit_logs/).any?
        skip unless defined?(Book)
        super
        @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
      end

      test "the audit_logs option is added to super scaffolding" do
        assert `./bin/super-scaffold`.include?("audit_logs")
      end

      test "The book model has audit logs" do
        login_as(@jane, scope: :user)
        visit account_team_path(@jane.current_team)

        assert_text("Books")
        click_on "Add New Book"

        assert_text("New Book Details")
        fill_in "Title", with: "The Stand"
        fill_in "Author", with: "Stephen King"

        click_on "Create Book"
        click_on "Back"

        assert_text("Books")
        assert_text("The Stand")
        click_on "The Stand"
        assert_text("Edit Book")
        click_on "Activity"
        assert_text("Created the Book The Stand")
      end
    end
  end
end
