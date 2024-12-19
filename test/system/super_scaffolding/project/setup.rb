#!/usr/bin/env ruby

require_relative "../super_scaffolding_test_setup"

class Setup < SuperScaffoldingTestSetup
  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      puts `rails g super_scaffold Project Team name:text_field description:trix_editor --navbar="ti-layout"`
      puts `rails g super_scaffold Projects::Deliverable Project,Team name:text_field description:trix_editor`

      # Setup for has-many-through test.
      puts `rails g super_scaffold Projects::Tag Team name:text_field --navbar="ti-tag"`

      puts `rails g super_scaffold:join_model Projects::AppliedTag project_id{class_name=Project} tag_id{class_name=Projects::Tag}`
      puts `rails g super_scaffold:field Project tag_ids:super_select{class_name=Projects::Tag}`

      # This "implements" the valid_* method
      # We change this line:
      # raise "please review and implement `valid_projects_tags` in `app/models/projects.rb`."
      # to this:
      # team.projects_tags
      if Gem::Platform.local.os == "darwin"
        puts `sed -i "" "s/raise .*/team\.projects_tags/g" app/models/project.rb`
      else
        puts `sed -i "s/raise .*/team\.projects_tags/g" app/models/project.rb`
      end
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `scaffolding_setup` on the command line
args = ["scaffolding_setup"] + ARGV

Setup.start(args)
