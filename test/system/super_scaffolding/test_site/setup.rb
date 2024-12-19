#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts "do the thing"
      puts `rails g super_scaffold TestSite Team name:text_field other_attribute:text_field url:text_field --navbar="ti-world" --sortable`
      puts `rails g super_scaffold TestPage TestSite,Team name:text_field path:text_field`
      puts `rails g super_scaffold:field TestSite membership_id:super_select{class_name=Membership}`

      # This "implements" the valid_memberships method on test_site.
      # We change this line:
      # raise "please review and implement `valid_memberships` in `app/models/test_site.rb`."
      # to this:
      # team.memberships
      if Gem::Platform.local.os == "darwin"
        puts `sed -i "" "s/raise .*/team\.memberships/g" app/models/test_site.rb`
      else
        puts `sed -i "s/raise .*/team\.memberships/g" app/models/test_site.rb`
      end

      # TODO: Do we want to include this here?
      # puts `bundle exec rails db:schema:load db:migrate db:test:prepare`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
