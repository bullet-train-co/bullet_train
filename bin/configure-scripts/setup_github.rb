#!/usr/bin/env ruby

require "#{__dir__}/utils"

puts "Next, let's push your application to GitHub."
puts "If you would like to use another service like Gitlab to manage your repository,"
puts "you can opt out of this step and set up the repository manually."
puts "(If you're not sure, we suggest going with GitHub)"
setup_github = ask_boolean "Continue setting up with GitHub?", "y"

puts "setup_github = #{setup_github}"
if setup_github
  if `git remote | grep origin`.strip.length > 0
    puts "Repository already has a \`origin`\ remote.".yellow
  else
    ask "Hit <Return> and we'll open a browser to GitHub where you can create a new repository. When you're done, copy the SSH path from the new repository and return here. We'll ask you to paste it to us in the next step."
    command = if Gem::Platform.local.os == "linux"
      "xdg-open"
    else
      "open"
    end
    `#{command} https://github.com/new`

    ssh_path = ask "OK, what was the SSH path? (It should look like `git@github.com:your-account/your-new-repo.git`. You can enter `skip` to skip this step.)"
    while ssh_path == ""
      puts "You must provide a path for your new repository.".red
      ssh_path = ask "What was the SSH path? (It should look like `git@github.com:your-account/your-new-repo.git`.)"
    end
    if ssh_path == "skip"
      return
    end
    puts "Setting repository's `origin` remote to `#{ssh_path}`.".green
    puts `git remote add origin #{ssh_path}`.chomp
  end

  push_to_origin = ask_boolean "Should we push this repo to `origin`?", "y"
  if push_to_origin
    puts "Pushing repository to `origin`.".green
    # TODO: We used to do this to push whatever the current branch is to `main`:
    # local_branch = `git branch | grep "*"`.split.last
    # stream "git push origin #{local_branch}:main 2>&1"
    #
    # I'm not sure that's a great thing to do, so for now I'm just doing a bare
    # push. Are there reasons that would be inadequate?

    stream "git push origin 2>&1"
  else
    puts "Skipping pushing to origin.".yellow
  end
end
