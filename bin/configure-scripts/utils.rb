#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "colorize"
  gem "activesupport", require: "active_support"
end

def ask(string)
  puts string.blue
  gets.strip
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

def stream(command, prefix = "  ")
  puts ""
  IO.popen(command) do |io|
    while (line = io.gets)
      puts "#{prefix}#{line}"
    end
  end
  puts ""
end

def replace_in_file(file, before, after, target_regexp = nil)
  puts "Replacing in '#{file}'."
  if target_regexp
    target_file_content = ""
    File.open(file).each_line do |l|
      l.gsub!(before, after) if !!l.match(target_regexp)
      # standard:disable Lint/Void
      # TODO: Does this line even do anything for us?
      l if !!l.match(target_regexp)
      # standard:enable Lint/Void
      target_file_content += l
    end
  else
    target_file_content = File.read(file)
    target_file_content.gsub!(before, after)
  end
  File.write(file, target_file_content)
end

def announce_section(section_name)
  puts ""
  puts "".ljust(80, "-").cyan
  puts section_name.cyan
  puts ""
end
