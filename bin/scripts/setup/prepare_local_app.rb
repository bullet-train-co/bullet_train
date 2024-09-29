#!/usr/bin/env ruby

require File.expand_path("../utils", __dir__)

announce_section 'Preparing local app files'

puts "\n== Preparing database =="
system! 'bin/rails db:prepare'

puts "\n== Removing old logs and tempfiles =="
system! 'bin/rails log:clear tmp:clear'

puts "\n== Copying `config/application.yml.example` to `config/application.yml`. =="
if File.exist?('config/application.yml')
  puts '`config/application.yml` already exists!'
else
  system! 'cp config/application.yml.example config/application.yml'
end
