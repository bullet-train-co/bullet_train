#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Skipping icu4c"

puts "The bullet_train-conversations gem is not in the Gemfile, so we're skipping icu4c.".yellow
puts "If you want to manually run checks for icu4c you can run the following command:".yellow
puts "./bin/setup-scripts/check_icu.rb".yellow
puts ""
