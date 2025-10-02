#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking yarn"

package_json = JSON.parse(File.read("package.json"))

required_yarn = package_json["packageManager"].split("@").last

actual_yarn = begin
  `yarn -v`.strip
rescue
  :not_found
end

if actual_yarn != :not_found && actual_yarn != required_yarn
  # Yarn is installed but is not the correct verison.
  # Running `corepack enable` usually allows yarn to fix this situation itself.
  # So we run `corepack enable` and then capture the version number again.
  system!("corepack enable")
  actual_yarn = `yarn -v`.strip
end

message = "Bullet Train requires yarn #{required_yarn} and `yarn -v` returns #{actual_yarn}."
if actual_yarn == :not_found || actual_yarn == ""
  puts "You don't have yarn installed. We can't proceed without it. Try `npm install -g yarn && corepack enable`.".red
  exit
elsif Gem::Version.new(actual_yarn) >= Gem::Version.new(required_yarn)
  puts message.green
else
  puts message.red
  continue_anyway = ask_boolean "Try proceeding with yarn #{actual_yarn} anyway?", "y"
  if continue_anyway
    puts "You've chosen to continue with yarn #{actual_yarn}.".yellow
  else
    puts "You've chosen not to continue with yarn #{actual_yarn}. Goodbye.".red
    exit
  end
end
