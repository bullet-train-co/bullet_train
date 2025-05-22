# frozen_string_literal: true
#
# We clear and override the stimulus:manifest:update task to avoid having it clobber
# our custom and non-standard stimulus manifest file.
# For details about why, see this issue:
# https://github.com/bullet-train-co/bullet_train/issues/2011

override_default_stimulus_manifest_update_task = true

if override_default_stimulus_manifest_update_task
  Rake::Task["stimulus:manifest:update"].clear
  namespace :stimulus do
    namespace :manifest do
      task :update do
        require "colorize"
        puts "-----------------------------------------------------------------------------------".yellow
        puts "We are skipping the stimulus:manifest:update task to avoid clobbering our manifest.".yellow
        puts "If you need to run this task see lib/tasks/stimulus_manifest_update_override.rake".yellow
        puts "-----------------------------------------------------------------------------------".yellow
      end
    end
  end
end
