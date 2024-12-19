#!/usr/bin/env ruby

require "thor"

class SuperScaffoldingTestTeardown < Thor
  # TODO: Need better naming and description.
  desc "scaffolding_teardown", "Run the teardown method for this test."
  option :allow_dirty_workspace
  def scaffolding_teardown
    if db_schema_has_changed
      puts "db/schema.rb has changed - we need to rollback"
      rollback
    else
      puts "db/schema.rb has not changed - no need to rollback"
    end
    clean_workspace
    teardown
  end

  # This allows failure to be reported to the shell correctly.
  # https://github.com/rails/thor/wiki/Making-An-Executable
  def self.exit_on_failure?
    true
  end

  # This allows us to define helper methods that aren't attached to thor commands
  no_commands do
    def clean_workspace
      puts `git checkout app config db test`
      puts `git clean -d -f app config db test`
    end

    def db_schema_has_changed
      `git diff --exit-code db/schema.rb`
      !$?.success?
    end

    def rollback
      puts `bundle exec rails db:rollback STEP=#{commits_to_rollback}`
    end

    def commits_to_rollback
      `git status | grep -c db/migrate`
    end

    def teardown
      raise "Your subcommand should define the teardown method."
    end
  end
end

# We create our own args array so that we don't have to ask the user to include `bump` on the command line
# args = ["teardown"] + ARGV

# Teardown.start(args)
