#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  require "fileutils"
  require "colorize"
  require "json"
end

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

def command?(name)
  [name,
    *ENV["PATH"].split(File::PATH_SEPARATOR).map { |p| File.join(p, name) }].find { |f| File.executable?(f) }
end

def announce_section(section_name)
  puts ""
  puts "".ljust(80, "-").cyan
  puts section_name.cyan
  puts ""
end

def ask_boolean(question, default = "y")
  choices = (default.downcase[0] == "y") ? "[Y/n]" : "[y/N]"
  puts "#{question} #{choices}".blue
  answer = gets.strip.downcase[0]
  if !answer
    answer = default.downcase
  end
  answer == "y"
end
