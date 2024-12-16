#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking PostgreSQL"

postgres_version_info = begin
  `postgres --version`
rescue
  "not found"
end

psql_version_info = begin
  `psql --version`
rescue
  "not found"
end

if /postgres/.match?(postgres_version_info.downcase)
  postgres_version = postgres_version_info.split("\s")[2]

  if postgres_version.match?(/^14/)
    puts "You have PostgreSQL 14 installed.".green

    postgres_running = system("pg_isready > /dev/null 2>&1")
    if postgres_running
      puts "PostgreSQL is running.".green
    else
      puts "PostgreSQL is installed but not running. You will need it in the DB setup steps.".red
      stop_now = ask_boolean "Would you like to stop here and start PostgreSQL first?", "n"
      if stop_now
        puts "PostgreSQL is not running and you've chosen to start it first. Run bin/setup again after.".red
        exit
      else
        puts "Continuing without PostgreSQL running. You will need it in the next setup steps.".yellow
      end
    end
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
elsif /postgres/.match?(psql_version_info.downcase)
  psql_version = psql_version_info.split("\s")[2]

  if psql_version.match?(/^14/)
    puts "You have PostgreSQL 14 installed.".green

    postgres_running = system("pg_isready > /dev/null 2>&1")
    if postgres_running
      puts "PostgreSQL is running.".green
    else
      puts "PostgreSQL is installed but not running. You will need it in the DB setup steps.".red
      stop_now = ask_boolean "Would you like to stop here and start PostgreSQL first?", "n"
      if stop_now
        puts "PostgreSQL is not running and you've chosen to start it first. Run bin/setup again after.".red
        exit
      else
        puts "Continuing without PostgreSQL running. You will need it in the next setup steps.".yellow
      end
    end
  else
    puts "You have PostgreSQL installed, but you're using v#{psql_version} and not v14.".red
    continue_anyway = ask_boolean "Try proceeding without PostgreSQL 14?", "y"
    if continue_anyway
      puts "Continuing with PostgreSQL v#{psql_version}. This might cause problems in the next steps.".yellow
    else
      puts "PostgreSQL v14 is not installed. And you've chosen not to continue. Goodbye.".red
      exit
    end
  end
else
  puts "You don't seem to have PostgreSQL installed.".red
  continue_anyway = ask_boolean "Would you like to try to continue without PostgreSQL?", "n"
  if continue_anyway
    puts "Continuing without PostgreSQL. This might cause problems in the next steps.".yellow
  else
    puts "PostgreSQL is not installed. And you've chosen not to continue. Goodbye.".red
    exit
  end
end
puts ""
