#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts `rails g super_scaffold TestFile Team name:text_field foo:file_field bars:file_field{multiple} --navbar="ti-tag"`
      puts `rails g super_scaffold ColorPicker Team color_picker_value:color_picker --navbar="ti-tag"`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
