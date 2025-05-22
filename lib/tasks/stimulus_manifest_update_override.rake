# frozen_string_literal: true
#
# We clear and override the stimulus:manifest:update task to avoid having it clobber
# our custom and non-standard stimulus manifest file.
# For details about why, see this issue:
# https://github.com/bullet-train-co/bullet_train/issues/2011

override_default_stimulus_manifest_update_task = ARGV[1] != "--clobber"

if override_default_stimulus_manifest_update_task
  Rake::Task["stimulus:manifest:update"].clear
  namespace :stimulus do
    namespace :manifest do
      task :update do
        require "colorize"
        puts "-----------------------------------------------------------------------------------".yellow
        puts "We are skipping the stimulus:manifest:update task to avoid clobbering our manifest.".yellow
        puts "If you need to run this task pass it the `--clobber` option like this:".yellow
        puts "    bin/rails stimulus:manifest:update -- --clobber".yellow
        puts "-----------------------------------------------------------------------------------".yellow
      end
    end
  end
end
