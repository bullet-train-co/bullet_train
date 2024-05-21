#!/usr/bin/env ruby

require "#{__dir__}/utils"

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
    `git remote rename origin bullet-train`
  end
else
  puts "Repository has no `origin` remote, but also no `bullet-train` remote. Did something go wrong?".red
end
puts ""
