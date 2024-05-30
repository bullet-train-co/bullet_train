#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Checking Ruby"

# Unless the shell's current version of Ruby is the same as what the application requires, we should flag it.
# rbenv produces strings like "3.1.2" while rvm produces ones like "ruby-3.1.2", so we account for that here.
required_ruby = `cat ./.ruby-version`.strip.gsub(/^ruby-/, "")
actual_ruby = `ruby -v`.strip
message = "Bullet Train requires Ruby #{required_ruby} and `ruby -v` returns #{actual_ruby}."
if actual_ruby.include?(required_ruby)
  puts message.green
else
  puts message.red
  input = ask "Try proceeding with with Ruby #{actual_ruby} anyway? [y/n]"
  if input.downcase[0] == "n"
    exit
  end
end
