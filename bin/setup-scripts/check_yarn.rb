#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking yarn"

package_json = JSON.parse(File.read("package.json"))

required_yarn = package_json["packageManager"].split("@").last

# Yarn is provided by Corepack (https://github.com/nodejs/corepack), which reads the `packageManager`
# field in package.json and runs exactly that version. We intentionally don't tell people to install
# yarn itself with npm or Homebrew: those copies fight with Corepack's `yarn` shim over the same bin
# directory, which is what used to break `brew bundle` before we removed `brew "yarn"` from the Brewfile.
def yarn_version
  `yarn -v`.strip
rescue
  :not_found
end

actual_yarn = yarn_version
corepack_available = command?("corepack")

if actual_yarn != required_yarn
  # Either yarn is missing, or it's installed but isn't the version we need. In both cases
  # `corepack enable` (re)creates the `yarn` shim, after which `yarn -v` reports the version
  # from package.json. So we run it and then capture the version number again.
  if corepack_available
    puts "`yarn -v` didn't return #{required_yarn}, so we're running `corepack enable` to set it up.".yellow
    unless system("corepack enable")
      puts "`corepack enable` failed. See the output above for details.".yellow
    end
    actual_yarn = yarn_version
  elsif actual_yarn == :not_found || actual_yarn == "" || Gem::Version.new(actual_yarn) < Gem::Version.new(required_yarn)
    # A newer yarn already satisfies the check below, so we only explain Corepack when yarn is missing or too old.
    puts "Corepack isn't installed, so we can't set up yarn #{required_yarn} for you.".yellow
    puts "Node.js 24 and older bundle Corepack, so if you're on one of those, check your Node.js installation.".yellow
    puts "Node.js 25 and newer don't bundle it, so install it with `npm install -g corepack`.".yellow
    puts "Once you have Corepack, run `corepack enable`. Don't install yarn itself with npm or Homebrew; Corepack provides it.".yellow
    puts ""
  end
end

message = "Bullet Train requires yarn #{required_yarn} and `yarn -v` returns #{actual_yarn}."
if actual_yarn == :not_found || actual_yarn == ""
  if corepack_available
    puts "We ran `corepack enable`, but `yarn -v` still doesn't return a version number. We can't proceed without yarn.".red
    puts "Check the output above for errors (Corepack downloads yarn #{required_yarn} the first time it runs), then run bin/setup again.".red
  else
    puts "You don't have yarn installed. We can't proceed without it. Install Corepack as described above, then run bin/setup again.".red
  end
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
