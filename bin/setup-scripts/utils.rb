#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source 'https://rubygems.org'
  require 'fileutils'
  require 'colorize'
end

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

def command?(name)
  [name,
   *ENV['PATH'].split(File::PATH_SEPARATOR).map {|p| File.join(p, name)}
  ].find {|f| File.executable?(f)}
end


