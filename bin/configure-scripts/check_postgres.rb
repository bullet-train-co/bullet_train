#!/usr/bin/env ruby

require "#{__dir__}/utils"

postgres_version_info = `postgres --version`

puts ""
if /postgres/.match?(postgres_version_info.downcase)
  postgres_version = postgres_version_info.split("\s")[2]

  if postgres_version.match?(/^14/)
    puts "You have PostgreSQL 14 installed.".green
  else
    puts "You have PostgreSQL installed, but you're using v#{postgres_version} and not v14.".red
    continue_anyway = ask_boolean "Try proceeding without PostgreSQL 14?", "y"
    if continue_anyway
      puts "Continuing with PostgreSQL v#{postgres_version}. This might cause problems in the next steps.".yellow
    else
      puts "PostgreSQL v14 is not installed. And you've chosen not to continue. Goodbye.".red
      exit
    end
  end
else
  puts "You don't seem to have PostgreSQL installed.".red
  continue_anyway = ask_boolan "Would you like to try to continue without PostgreSQL?", "n"
  if continue_anyway
    puts "Continuing without PostgreSQL. This might cause problems in the next steps.".yellow
  else
    puts "PostgreSQL is not installed. And you've chosen not to continue. Goodbye.".red
    exit
  end
end
puts ""
