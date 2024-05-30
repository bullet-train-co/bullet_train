#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Setup GitHub"

puts "Next, let's push your application to GitHub."
puts "If you would like to use another service like Gitlab to manage your repository,"
puts "you can opt out of this step and set up the repository manually."
puts "(If you're not sure, we suggest going with GitHub)"
setup_github = ask_boolean "Continue setting up with GitHub?", "y"

puts "setup_github = #{setup_github}"
if setup_github
  if `git remote | grep origin`.strip.length > 0
    puts "Repository already has a `origin` remote.".yellow
  else
    ask "Hit <Return> and we'll open a browser to GitHub where you can create a new repository. When you're done, copy the SSH path from the new repository and return here. We'll ask you to paste it to us in the next step."
    command = if Gem::Platform.local.os == "linux"
      "xdg-open"
    else
      "open"
    end
    `#{command} https://github.com/new`

    ssh_path = ask "OK, what was the SSH path? (It should look like `git@github.com:your-account/your-new-repo.git`. You can enter `skip` to bail out of GitHub setup.)"
    while ssh_path == ""
      puts "You must provide a path for your new repository.".red
      ssh_path = ask "What was the SSH path? (It should look like `git@github.com:your-account/your-new-repo.git`. you can enter `skip` to bail out of GitHub setup.)"
    end
    if ssh_path == "skip"
      puts "Bailing out of GitHub setup.".yellow
      return
    end
    puts "Setting repository's `origin` remote to `#{ssh_path}`.".green
    puts `git remote add origin #{ssh_path}`.chomp
  end
end
