#!/usr/bin/env ruby

require_relative "../utils"

announce_section "Checking Docker"

if command?("docker")
  puts "Docker is installed.".green
  if system("docker info &> /dev/null")
    puts "Docker engine is running.".green
  elsif ask_boolean("Docker engine is not running. Would you like to start it?", "y")
    start_docker
  else
    puts "Please start docker engine yourself and restart bin/setup. Goodbye.".red
    exit
  end
else
  puts "Docker not found".red
  puts "Docker is required to run the postgres and redis services.".red
  puts "Visit https://docs.docker.com/get-docker/ for more information.".red
  exit
end
