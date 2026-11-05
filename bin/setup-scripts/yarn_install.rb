#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Yarn install"

# check_yarn.rb has already run `corepack enable` if it was needed, so this call is theoretically
# redundant. We keep it as a failsafe, but we don't abort if it fails or if Corepack isn't installed
# (Node.js 25 and newer don't bundle it), because yarn itself was already verified by check_yarn.rb.
system("corepack enable") if command?("corepack")
system!("yarn install")
