#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'colorize'
  gem 'json'
  gem 'activesupport', require: 'active_support'
  gem 'fileutils'
end

def announce_section(section_name)
  puts ''
  puts ''.ljust(80, '-').cyan
  puts section_name.cyan
  puts ''
end

def ask(string)
  puts string.blue
  gets.strip
end

def ask_boolean(question, default = 'y')
  choices = default.downcase[0] == 'y' ? '[Y/n]' : '[y/N]'
  puts "#{question} #{choices}".blue
  answer = gets.strip.downcase[0]
  answer ||= default.downcase
  answer == 'y'
end

def command?(name)
  [name,
   *ENV['PATH'].split(File::PATH_SEPARATOR).map { |p| File.join(p, name) }].find { |f| File.executable?(f) }
end

def replace_in_file(file, before, after, target_regexp = nil)
  puts "Replacing in '#{file}'."
  if target_regexp
    target_file_content = ''
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

def stream(command, prefix = '  ')
  puts ''
  IO.popen(command) do |io|
    while (line = io.gets)
      puts "#{prefix}#{line}"
    end
  end
  puts ''
end

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end
