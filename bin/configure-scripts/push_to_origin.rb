#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Push to origin"

has_origin_remote = `git remote | grep origin`.strip.length > 0
if has_origin_remote
  push_to_origin = ask_boolean "Should we push this repo to `origin`?", "y"
  if push_to_origin
    puts "Pushing repository to `origin`.".green
    stream "git push --set-upstream origin main:main 2>&1"
  else
    puts "Skipping pushing to origin.".yellow
  end
else
  puts "This repo doesn't appear to have an `origin` remote configured. Skipping pushing to `origin`.".red
end
