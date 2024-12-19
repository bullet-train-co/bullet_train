#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts `rails g super_scaffold Projects::Step Team name:text_field description:trix_editor --navbar="ti-world"`
      puts `rails g super_scaffold Objective Projects::Step,Team name:text_field description:trix_editor`

      # TODO: Do we want to include this here?
      # puts `bundle exec rails db:schema:load db:migrate db:test:prepare`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
