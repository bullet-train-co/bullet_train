#!/usr/bin/env ruby

puts ""
puts `gem install activesupport`
puts ""

require "#{__dir__}/utils"
require 'active_support'

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

human = ask "What is the name of your new application in title case? (e.g. \"Some Great Application\")"
while human == ""
  puts "You must provide a name for your application.".red
  human = ask "What is the name of your new application in title case? (e.g. \"Some Great Application\")"
end

require "active_support/inflector"

variable = ActiveSupport::Inflector.parameterize(human.gsub("-", " "), separator: '_')
environment_variable = ActiveSupport::Inflector.parameterize(human.gsub("-", " "), separator: '_').upcase
class_name = variable.classify
kebab_case = variable.tr("_", "-")
connected_name = variable.gsub("_", "") # i.e. `bullettrain` as opposed to `bullet_train`

puts ""
puts "Replacing instances of \"Untitled Application\" with \"#{human}\" throughout the codebase.".green
replace_in_file("./.circleci/config.yml", "untitled_application", variable)
replace_in_file("./config/application.rb", "untitled_application", connected_name)
replace_in_file("./config/database.yml", "untitled_application", variable)
replace_in_file("./config/database.yml", "UNTITLED_APPLICATION", environment_variable)
replace_in_file("./config/cable.yml", "untitled_application", variable)
replace_in_file("./config/initializers/session_store.rb", "untitled_application", variable)
replace_in_file("./config/environments/production.rb", "untitled_application", variable)
replace_in_file("./config/application.rb", "UntitledApplication", class_name)
replace_in_file("./config/locales/en/application.en.yml", "Untitled Application", human, /name/)
replace_in_file("./config/locales/en/application.en.yml", "untitled_application", variable)
replace_in_file("./config/locales/en/application.en.yml", "untitled application", human.downcase, /keywords/)
replace_in_file("./config/locales/en/user_mailer.en.yml", "Untitled Application", human)
replace_in_file("./zapier/package.json", "untitled-application", kebab_case)
replace_in_file("./zapier/package.json", "Untitled Application", human)
replace_in_file("./app/views/api/v1/open_api/index.yaml.erb", "Untitled Application", human)
replace_in_file("./app.json", "Untitled Application", human)
replace_in_file("./.redocly.yaml", "untitled_application", variable)

replace_in_file("./README.example.md", "Untitled Application", human)

puts ""

puts "Moving `./README.example.md` to `./README.md`.".green
puts `mv ./README.example.md ./README.md`.chomp

puts `rm .github/FUNDING.yml`.chomp

# TODO: Uncomment this when the enable bulk invitations JS is implemented.
# Enable the bulk invitations configuration.
# bt_config_lines = File.open("config/initializers/bullet_train.rb").readlines
# new_lines = bt_config_lines.map do |line|
#   if line.match?("config.enable_bulk_invitations")
#     line.gsub!(/#\s*/, "")
#   end
#   line
# end
# File.write("config/initializers/bullet_train.rb", bt_config_lines.join)


commit_changes = ask_boolean "Would you like to commit the changes to your project?", "y"
if commit_changes
  puts "Committing all these changes to the repository.".green
  stream "git add -A"
  stream "git commit -m \"Run configuration script.\""
else
  puts ""
  puts "Make sure you save your changes with Git.".yellow
end
