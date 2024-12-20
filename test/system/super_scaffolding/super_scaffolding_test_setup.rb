#!/usr/bin/env ruby

require "thor"

class SuperScaffoldingTestSetup < Thor
  # TODO: Need better naming and description.
  desc "scaffolding_setup", "Run the setup method for this test."
  option :allow_dirty_workspace
  def scaffolding_setup
    if !git_workspace_clean && !options[:allow_dirty_workspace]
      banner = <<~BANNER
        --------------------------------------------------------------------------------------------------------
        - It looks like your git workspace is not clean.
        - This script will generate a bunch of stuff that you probably don't want to keep.
        - The teardown script may clobber your other changes, so we don't recommend running setup in a dirty workspace.
        -
        - If you really want to run this with your current non-clean workspace
        - then you can pass the `--allow-dirty-workspace` flag to skip this notice and run the script.
        -
        - For example:
        - ./test/system/super_scaffolding/test_site/setup.rb --allow-dirty-workspace
        -------------------------------------------------------------------------------------------------------
      BANNER
      say_error banner, :red
      return 1
    end
    setup
    migrate
  end

  # This allows failure to be reported to the shell correctly.
  # https://github.com/rails/thor/wiki/Making-An-Executable
  def self.exit_on_failure?
    true
  end

  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def setup
      raise "Your subcommand should define the setup method."
    end

    def migrate
      puts `bundle exec rails db:migrate db:test:prepare`
    end

    def git_workspace_clean
      # Are there unstaged changes?
      `git diff --exit-code`
      unstaged_changes_present = !$?.success?

      `git diff --cached --exit-code`
      staged_changes_present = !$?.success?

      # puts "workspace_is_clean = #{unstaged_changes_present && staged_changes_present}"

      unstaged_changes_present && staged_changes_present
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `bump` on the command line
# args = ["setup"] + ARGV

# Setup.start(args)
