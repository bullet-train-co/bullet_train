#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking Image Processing Dependencies"

def check_dependency(name, version_command)
  puts "\nChecking #{name}..."
  version_info = `#{version_command} 2>&1`

  if $?.success?
    version = version_info.split("\n").first
    puts "#{name} is installed: #{version}".green
  else
    puts "#{name} is not installed or not found in PATH.".red
    install_msg = case name
    when "vips"
      "Try `brew install vips` on macOS or `sudo apt-get install libvips` on Ubuntu."
    when "ImageMagick"
      "Try `brew install imagemagick` on macOS or `sudo apt-get install imagemagick` on Ubuntu."
    end
    puts install_msg

    continue_anyway = ask_boolean "Would you like to continue without #{name}?", "n"
    if continue_anyway
      puts "Continuing without #{name}. This can prevent Rails scripts from running and cause problems with image processing.".yellow
    else
      puts "You've chosen not to continue without #{name}. Goodbye.".red
      exit
    end
  end
end

check_dependency("vips", "vips --version")
check_dependency("ImageMagick", "magick -version")

puts "\nImage processing dependency check completed.".green