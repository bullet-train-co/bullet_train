# frozen_string_literal: true

# We clear and override the action_text:install task to avoid confusion and duplication.
# We already have all of the ActionText stuff in the `core` repo, so including it in the
# starter repo is redundant and and possible source of confusion.

override_default_action_text_install_task = ARGV[1] != "--clobber"

if override_default_action_text_install_task
  Rake::Task["action_text:install"].clear
  namespace :action_text do
    task :install do
      require "colorize"
      puts "-------------------------------------------------------------------------------------------------".yellow
      puts "We are skipping the action_text:install task because we configure ActionText via the `core` repo.".yellow
      puts "If you need to run this task pass it the `--clobber` option like this:".yellow
      puts "    bin/rails action_text:install -- --clobber".yellow
      puts "-------------------------------------------------------------------------------------------------".yellow
    end
  end
end
