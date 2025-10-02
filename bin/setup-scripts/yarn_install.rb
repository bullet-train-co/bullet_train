#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Yarn install"

# Theoretically this call to `corepack enable` is redundant, but we're including it as a failsafe.
system!("corepack enable")
system!("yarn install")
