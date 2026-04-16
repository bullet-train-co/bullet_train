#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking Homebrew Dependencies"

brewfile_path = File.expand_path("../../Brewfile", __dir__)

unless File.exist?(brewfile_path)
  puts "No Brewfile found, skipping.".yellow
  puts ""
  return
end

case Gem::Platform.local.os
when "darwin"
  if command?("brew")
    puts "Brewfile found. Installing Homebrew dependencies...".green
    puts ""
    system!("brew bundle --file=#{brewfile_path}")
    puts ""
    puts "Homebrew dependencies installed.".green
  else
    puts "Homebrew is not installed.".red
    puts "You can install it from https://brew.sh".yellow
    puts ""
    puts "Without Homebrew, you'll need to manually install these dependencies:".yellow
    File.readlines(brewfile_path).each do |line|
      if line.match?(/^brew "(.+)"/)
        package = line.match(/^brew "(.+)"/)[1]
        puts "  - #{package}".yellow
      end
    end
    puts ""
    continue_anyway = ask_boolean "Would you like to continue without installing Homebrew dependencies?", "n"
    if continue_anyway
      puts "Continuing without Homebrew dependencies. This may cause problems.".yellow
    else
      puts "You've chosen not to continue. Please install Homebrew and run bin/setup again.".red
      exit
    end
  end
else
  puts "Skipping Homebrew (not on macOS).".yellow
  puts "Please ensure you have the equivalent packages installed for your system:".yellow
  File.readlines(brewfile_path).each do |line|
    if line.match?(/^brew "(.+)"/)
      package = line.match(/^brew "(.+)"/)[1]
      puts "  - #{package}".yellow
    end
  end
end

puts ""
