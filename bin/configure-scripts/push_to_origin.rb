#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Push to origin"

has_origin_remote = `git remote | grep origin`.strip.length > 0
if has_origin_remote
  push_to_origin = ask_boolean "Should we push this repo to `origin`?", "y"
  if push_to_origin
    puts "Pushing repository to `origin`.".green
    # TODO: We used to do this to push whatever the current branch is to `main`:
    # local_branch = `git branch | grep "*"`.split.last
    # stream "git push origin #{local_branch}:main 2>&1"
    #
    # I'm not sure that's a great thing to do, so for now I'm just doing a bare
    # push. Are there reasons that would be inadequate?

    stream "git push origin 2>&1"
  else
    puts "Skipping pushing to origin.".yellow
  end
else
  puts "This repo doesn't appear to have an `origin` remote configured. Skipping pushing to `origin`.".red
end
