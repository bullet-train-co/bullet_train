#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking Overmind"

if command?("overmind")
  puts "Overmind is already installed.".green
else
  puts "Overmind not found".red
  puts "We recommend installing overmind to run your application processes"
  puts "Visit https://github.com/DarthSim/overmind#installation for more information."
  if ask_boolean "Would you like to continue without overmind?"
    puts "Continuing without overmind."
  else
    puts "You chose not to continue without overmind. Goodbye.".red
    exit
  end
end
