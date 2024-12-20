#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts `rails g super_scaffold Personality::Disposition Team name:text_field description:trix_editor --navbar="ti-world"`
      puts `rails g super_scaffold Personality::Note Personality::Disposition,Team name:text_field description:trix_editor`

      # Test that the foreign key table name will be inserted into the migration.
      puts `rails g super_scaffold:field Personality::Note other_membership_id:super_select{"class_name=Membership,source=team.memberships"}`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
