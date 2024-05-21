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



