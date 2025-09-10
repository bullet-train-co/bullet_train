#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Add a 'Deploy to Heroku' button?"

button_file = "#{__dir__}/deploy-buttons/heroku.md"

add_button = ask_boolean "Would you like to add a 'Deploy to Heroku' button to your project.", "y"
if add_button
  puts "Adding a 'Deploy to Heroku' button.".green
  new_repo_link = if defined?(SETUP_GITHUB) && SETUP_GITHUB
    HTTP_PATH
  else
    ask "What is the https variant of your repo URL? (Something like: https://github.com/your-org/your-repo)"
  end

  File.open("README.md", "a") do |readme|
    button = File.read(button_file)
    button.each_line do |line|
      readme << line
    end
  end

  original_repo_link = "https://github.com/bullet-train-co/bullet_train"

  replace_in_file("README.md", original_repo_link, new_repo_link, /template=#{original_repo_link}/)
else
  puts "Not adding a 'Deploy to Heroku' button.".yellow
end
