#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Rename origin remote"

has_bt_remote = `git remote | grep bullet-train`.strip.length > 0
has_origin_remote = `git remote | grep origin`.strip.length > 0

puts ""
if has_bt_remote && has_origin_remote
  puts "Repository already has a `bullet-train` remote and an `origin` remote.".yellow
elsif has_bt_remote
  puts "Repository already has a `bullet-train` remote.".yellow
elsif has_origin_remote
  puts "We recommend renaming the `origin` remote to `bullet-train`.".green
  rename_origin = ask_boolean "Should we rename your `origin` remote to `bullet-train`?", "y"
  if rename_origin
    puts "Renaming `origin` remote to `bullet-train`".green
    `git remote rename origin bullet-train`
  else
    puts "Skipping renaming `origin` remote to `bullet-train`.".yellow
  end
else
  puts "Repository has no `origin` remote, but also no `bullet-train` remote. Did something go wrong?".red
end
puts ""
