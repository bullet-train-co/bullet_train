#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Building assets"

puts "-------- yarn run build"
system!("yarn run build")

puts "-------- yarn run build:css"
system!("yarn run build:css")

puts "-------- yarn run ligh:build:css"
system!("yarn run light:build:css")


