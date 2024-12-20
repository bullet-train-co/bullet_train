#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts `rails g super_scaffold TestSite Team name:text_field other_attribute:text_field url:text_field --navbar="ti-world" --sortable`
      puts `rails g super_scaffold TestPage TestSite,Team name:text_field path:text_field`
      puts `rails g super_scaffold:field TestSite membership_id:super_select{"class_name=Membership,source=team.memberships"}`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
