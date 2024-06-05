#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking Redis"

redis_version_info = begin
  `redis-cli --version`
rescue
  "not found"
end

puts ""
if /redis/.match?(redis_version_info.downcase)
  redis_version = redis_version_info.split("\s")[1]
  puts "You have redis #{redis_version} installed.".green
else
  puts "You don't seem to have redis installed.".red
  continue_anyway = ask_boolean "Would you like to try to continue without redis?", "n"
  if continue_anyway
    puts "Continuing without redis. This might cause problems in the next steps.".yellow
  else
    puts "redis is not installed. And you've chosen not to continue. Goodbye.".red
    exit
  end
end
puts ""
