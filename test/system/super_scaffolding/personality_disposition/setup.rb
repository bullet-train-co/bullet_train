#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts `rails g super_scaffold Personality::Disposition Team name:text_field description:trix_editor --navbar="ti-world"`
      puts `rails g super_scaffold Personality::Note Personality::Disposition,Team name:text_field description:trix_editor`

      # Test that the foreign key table name will be inserted into the migration.
      puts `rails g super_scaffold:field Personality::Note other_membership_id:super_select{class_name=Membership}`

      # This "implements" the valid_* method
      # We change this line:
      # raise "please review and implement `valid_memberships` in `app/models/personality/note.rb`."
      # to this:
      # team.memberships
      if Gem::Platform.local.os == "darwin"
        puts `sed -i "" "s/raise .*/team\.memberships/g" app/models/personality/note.rb`
      else
        puts `sed -i "s/raise .*/team\.memberships/g" app/models/personality/note.rb`
      end

      # TODO: Do we want to include this here?
      # puts `bundle exec rails db:schema:load db:migrate db:test:prepare`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
