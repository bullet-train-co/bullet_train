#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_teardown"

class Teardown < SuperScaffoldingTestTeardown
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def teardown
      # custom teardown goes here
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_teardown"] + ARGV

Teardown.start(args)
