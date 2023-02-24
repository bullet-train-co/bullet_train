require "application_system_test_case"

module BulletTrainGems
  module AuditLogs
    class SuperScaffoldingSystemTest < ApplicationSystemTestCase
      def setup
        skip unless File.readlines("Gemfile").grep(/bullet_train-audit_logs/).any?
        super
        @jane = create :onboarded_user, first_name: "Jane", last_name: "Smith"
      end

      test "the audit_logs option is added to super scaffolding" do
        assert `./bin/super-scaffold`.include?("audit_logs")
      end
    end
  end
end
