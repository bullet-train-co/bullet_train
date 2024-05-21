#!/usr/bin/env ruby

puts ""
puts `gem install colorize`
puts ""

require 'colorize'
require 'active_support'

def ask(string)
  puts string.blue
  return gets.strip
end

def ask_boolean(question, default = 'y')
  choices = default.downcase[0] == 'y' ? "[Y/n]" : "[y/N]"
  puts "#{question} #{choices}".blue
  answer = gets.strip.downcase[0]
  if !answer
    answer = default.downcase
  end
  return answer == 'y'
end

def stream(command, prefix = "  ")
  puts ""
  IO.popen(command) do |io|
    while (line = io.gets) do
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
      l if !!l.match(target_regexp)
      target_file_content += l
    end
  else
    target_file_content = File.open(file).read
    target_file_content.gsub!(before, after)
  end
  File.open(file, "w+") do |f|
    f.write(target_file_content)
  end
end

