#!/usr/bin/env ruby

require_relative "../utils"

announce_section "Preparing local app files"

puts "\n== Preparing database =="

start_container "postgres"
system! "bin/rails db:prepare"
stop_container "postgres"

puts "\n== Removing old logs and tempfiles =="
system! "bin/rails log:clear tmp:clear"

puts "\n== Copying `config/application.yml.example` to `config/application.yml`. =="
if File.exist?("config/application.yml")
  puts "`config/application.yml` already exists!"
else
  system! "cp config/application.yml.example config/application.yml"
end
