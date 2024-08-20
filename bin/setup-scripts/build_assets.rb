#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Building assets"

# TODO: Do we still need to this seperately? It's part of `yarn build:css`
# system!("bin/link")

puts "-------- yarn run build"
system!("yarn run build")

puts "-------- yarn run build:css"
system!("yarn run build:css")

puts "-------- yarn run light:build:css"
system!("yarn run light:build:css")
