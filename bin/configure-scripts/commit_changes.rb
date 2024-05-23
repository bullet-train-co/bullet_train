#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Commit changes?"

commit_changes = ask_boolean "Would you like to commit the changes to your project?", "y"
if commit_changes
  puts "Committing all these changes to the repository.".green
  stream "git add -A"
  stream "git commit -m \"Run configuration script.\""
else
  puts ""
  puts "Make sure you save your changes with Git.".yellow
end
