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

  redis_running = system("redis-cli ping > /dev/null 2>&1")
  if redis_running
    puts "Redis is running.".green
  else
    puts "Redis is installed but not running. You will need it when starting your development app.".red
    stop_now = ask_boolean "Would you like to stop here and start Redis first?", "n"
    if stop_now
      puts "Redis is not running and you've chosen to start it first. Run bin/setup again after.".red
      exit
    else
      puts "Continuing without Redis running. You will need it when starting your development app.".yellow
    end
  end
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
