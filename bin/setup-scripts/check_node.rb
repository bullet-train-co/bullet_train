#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking NodeJS"

required_node = `cat ./.nvmrc`.strip
actual_node = begin
  `node -v`.strip.delete("v")
rescue
  :not_found
end
message = "Bullet Train requires Node.js #{required_node} and `node -v` returns #{actual_node}."
if actual_node == :not_found
  puts "You don't have Node installed. We can't proceed without it. Try `brew install node`.".red
  exit
elsif Gem::Version.new(actual_node) >= Gem::Version.new(required_node)
  puts message.green
else
  puts message.red
  continue_anyway = ask_boolean "Try proceeding with Node #{actual_node} anyway?", "y"
  if continue_anyway
    puts "You've chosen to continue with Node #{actual_node}.".yellow
  else
    puts "You've chosen not to continue with Node #{actual_node}. Goodbye.".red
    exit
  end
end
