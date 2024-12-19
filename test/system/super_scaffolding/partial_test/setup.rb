#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      command = %(
        rails g super_scaffold PartialTest Team \
            text_field_test:text_field \
            boolean_test:boolean \
            single_button_test:buttons \
            multiple_buttons_test:buttons{multiple} \
            date_test:date_field\
            date_time_test:date_and_time_field \
            file_test:file_field \
            option_test:options \
            multiple_options_test:options{multiple} \
            password_test:password_field \
            phone_field_test:phone_field \
            super_select_test:super_select \
            multiple_super_select_test:super_select{multiple} \
            number_field_test:number_field \
            text_area_test:text_area \
            address_test:address_field --navbar="ti-layout"
      )
      puts `#{command}`
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
