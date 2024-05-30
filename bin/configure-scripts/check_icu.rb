#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking icu4c"

def not_installed?(package)
  `brew info #{package} | grep "Not installed"`.strip.length > 0
end

def check_package(package)
  if not_installed?(package)
    puts "#{package} is not installed via Homebrew.".red
    install_package = ask_boolean "Would you like us to install it? (via: `brew install #{package}`)", "y"
    if install_package
      puts "brew install #{package}"
      stream "brew install #{package}"
      puts "#{package} should now be installed.".green
    else
      continue_anyway = ask_boolean "Try proceeding without #{package}?", "y"
      if continue_anyway
        puts "You have chosen to continue without `#{package}`.".yellow
      else
        puts "You have chosen not to continue without `#{package}`. Goodbye".red
        exit
      end
    end
  else
    puts "#{package} is installed via Homebrew.".green
  end
end

puts ""

case Gem::Platform.local.os
when "darwin"
  if `brew info 2> /dev/null`.length > 0
    puts "Homebrew is installed.".green
    puts ""
    check_package("icu4c")
  else
    puts "You don't have Homebrew installed. This isn't necessarily a problem, but we can't check your dependencies without it.".red
    continue_anyway = ask_boolean "Try proceeding without Homebrew?", "y"
    if continue_anyway
      puts "You've chosen to continue without Homebrew.".yellow
      puts "This means that we can't tell if you have `icu4c` installed.".yellow
    else
      puts "You don't have Homebrew and have chosen not to continue. Goodbye.".red
      exit
    end
  end
when "linux"
  dpkg_version_info = `dpkg --version`
  if dpkg_version_info.match?(/version/)
    system_packages = `dpkg -l | grep '^ii'`.split("\n").map do |package_information|
      package_information.split("\s")[1]
    end
    if system_packages.select { |pkg| pkg.match?(/^libicu/) }.any?
      puts "You have icu4c installed.".green
    else
      puts "You don't have icu4c installed.".red
      install_package = ask_boolean "Would you like us to install `icu4c`? (vi: Please run `sudo apt-get install libicu-dev`)", "y"
      if install_package
        puts "sudo apt-get install libicu-dev"
        stream "sudo apt-get install libicu-dev"
        puts "`icu4c` should now be installed."
      else
        continue_anyway = ask_boolean "Try proceeding without `icu4c`?", "y"
        if continue_anyway
          puts "You have chosen to continue without `icu4c`.".yellow
        else
          puts "You have chosen not to continue without `icu4c`. Goodbye".red
          exit
        end
        exit
      end
    end
  else
    puts "You don't have dpkg, so we can't tell if `icu4c` is installed.".red
    puts "Please make sure that `icu4c` is installed.".yellow
  end
else
  puts "We currently don't support this platform to check if you have `icu4c` installed.".red
  puts ""
  puts "Please ensure it is installed before proceeding."
  continue_anyway = ask_boolean "Proceed?", "y"
  if continue_anyway
    puts "Continuing with unknown status of `icu4c`.".yellow
  else
    puts "You have chosen not to continue with unknown status of `icu4c`. Goodbye.".red
    exit
  end
end

puts ""
