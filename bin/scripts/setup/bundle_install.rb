#!/usr/bin/env ruby

require_relative "../utils"

announce_section "Bundler setup"

system! "gem install bundler --conservative"
system("bundle check") || system!("bundle install")
