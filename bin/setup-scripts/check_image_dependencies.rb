#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking Image Processing Dependencies"

def check_dependency(name, version_command)
  puts "\nChecking #{name}..."
  version_info = `#{version_command} 2>&1`

  if $?.success?
    version = version_info.split("\n").first
    puts "#{name} is installed: #{version}".green
    true
  else
    puts "#{name} is not installed or not found in PATH.".red
    false
  end
end

vips_installed = check_dependency("vips", "vips --version")
magick_installed = check_dependency("ImageMagick", "magick -version")

if vips_installed || magick_installed
  # do nothing
else
  puts " "
  puts "--------------------------------------------".red
  puts "We couldn't find either vips or ImageMagick.".red
  puts " "
  puts "To install vips:"
  puts "Try `brew install vips` on macOS or `sudo apt-get install libvips` on Ubuntu."
  puts " "
  puts "To install ImageMagick:"
  puts "Try `brew install imagemagick` on macOS or `sudo apt-get install imagemagick` on Ubuntu."
  puts " "

  continue_anyway = ask_boolean "Would you like to continue without any image processing dependencies?", "n"
  if continue_anyway
    puts "Continuing without image processing dependencies. This can prevent Rails scripts from running and cause problems with image processing.".yellow
  else
    puts "You've chosen not to continue without image processing dependencies. Goodbye.".red
    exit
  end
end

puts "\nImage processing dependency check completed.".green
