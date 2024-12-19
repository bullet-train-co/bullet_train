#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup

      puts `rails g super_scaffold Personality::Observation Team name:text_field description:trix_editor --navbar="ti-world"`
      puts `rails g super_scaffold Personality::Reactions::Response Personality::Observation,Team name:text_field description:trix_editor`

      # This tweaks a test file for some reason?
      if Gem::Platform.local.os == "darwin"
        puts `sed -i "" "s/\@response/\@response_object/g" test/controllers/api/v1/personality/reactions/responses_controller_test.rb`
      else
        puts `sed -i "s/\@response/\@response_object/g" test/controllers/api/v1/personality/reactions/responses_controller_test.rb`
      end

      # TODO: Do we want to include this here?
      # puts `bundle exec rails db:schema:load db:migrate db:test:prepare`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
