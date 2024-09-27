#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "colorize"
  gem "json"
  gem "activesupport", require: "active_support"
  gem "fileutils"
end

def announce_section(section_name)
  puts ""
  puts "".ljust(80, "-").cyan
  puts section_name.cyan
  puts ""
end

def ask(string)
  puts string.blue
  gets.strip
end

def ask_boolean(question, default = "y")
  choices = (default.downcase[0] == "y") ? "[Y/n]" : "[y/N]"
  puts "#{question} #{choices}".blue
  answer = gets.strip.downcase[0]
  answer ||= default.downcase
  answer == "y"
end

def command?(name)
  [name,
    *ENV["PATH"].split(File::PATH_SEPARATOR).map { |p| File.join(p, name) }].find { |f| File.executable?(f) }
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

def stream(command, prefix = "  ")
  puts ""
  IO.popen(command) do |io|
    while (line = io.gets)
      puts "#{prefix}#{line}"
    end
  end
  puts ""
end

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

def overmind_quit
  return unless File.exist?(".overmind.sock")

  wait_for_overmind_quit if File.exist?(".overmind.sock")
  wait_for_overmind_kill if File.exist?(".overmind.sock")
  system("rm .overmind.sock") if File.exist?(".overmind.sock")
end

def wait_for_overmind_quit
  system("overmind quit")
  unless wait_for { !File.exist?(".overmind.sock") }
    puts "Overmind did not quit in time.".red
  end
end

def wait_for_overmind_kill
  system("overmind kill")
  unless wait_for { !File.exist?(".overmind.sock") }
    puts "Overmind did not die in time.".red
  end
end

def start_docker
  if platform.darwin?
    system!("open -a Docker")
    wait_for_docker
  elsif platform.linux?
    system("sudo systemctl start docker")
    wait_for_docker
  end
end

def wait_for_docker
  if wait_for { system("docker info &> /dev/null") }
    puts "Docker engine started successfully.".green
  else
    abort "Docker did not start in time.".red
  end
end

def start_containers
  system!("docker-compose up -d")
  wait_for_containers
end

def stop_containers
  system!("docker-compose down")
end

def start_container(container_name)
  system!("docker-compose up -d #{container_name}")
  wait_for_container(container_name)
end

def stop_container(container_name)
  system!("docker-compose down #{container_name}")
end

def wait_for_containers
  container_names = `docker-compose ps --services`.split("\n")

  container_names.map do |container_name|
    Thread.new do
      wait_for_container container_name
    end
  end.each(&:join)
end

def wait_for_container(container_name)
  puts "Waiting for #{container_name} to start.".yellow
  if wait_for { container_healthy?(container_name) }
    puts "#{container_name} is healthy.".green
  else
    abort "#{container_name} did not start in time.".red
  end
end

def container_healthy?(container_name)
  `docker inspect --format='{{.State.Health.Status}}' #{project_name}-#{container_name} 2>/dev/null`
    .include?("healthy")
end

def wait_for(wait: 0.25, timeout: 15, &block)
  start_time = Time.now

  while Time.now - start_time < timeout
    return true if block.call

    sleep wait
  end

  false
end

def project_name
  @project_name ||= File.basename(Dir.pwd)
end

def platform
  @platform ||= ActiveSupport::StringInquirer.new(Gem::Platform.local.os)
end
