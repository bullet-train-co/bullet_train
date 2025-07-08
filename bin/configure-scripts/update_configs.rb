#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Update project configs"

human = ask "What is the name of your new application in title case? (e.g. \"Some Great Application\")"
while human == ""
  puts "You must provide a name for your application.".red
  human = ask "What is the name of your new application in title case? (e.g. \"Some Great Application\")"
end

require "active_support/inflector"

# new_app_name
variable = ActiveSupport::Inflector.parameterize(human.tr("-", " "), separator: "_")
# NEW_APP_NAME
environment_variable = ActiveSupport::Inflector.parameterize(human.tr("-", " "), separator: "_").upcase
# NewAppName
class_name = variable.classify
# new-app-name
kebab_case = variable.tr("_", "-")
# newappname
connected_name = variable.delete("_")
# New-App-Name
http_header_style = ActiveSupport::Inflector.parameterize(human.tr("_", " "), separator: "-").titleize.tr(" ", "-")

puts ""
puts "Replacing instances of \"Untitled Application\" with \"#{human}\" throughout the codebase.".green
replace_in_file("./.circleci/config.yml", "untitled_application", variable)
replace_in_file("./config/application.rb", "untitled_application", connected_name)
replace_in_file("./config/database.yml", "untitled_application", variable)
replace_in_file("./config/database.yml", "UNTITLED_APPLICATION", environment_variable)
replace_in_file("./config/cable.yml", "untitled_application", variable)
replace_in_file("./config/initializers/session_store.rb", "untitled_application", variable)
replace_in_file("./config/environments/production.rb", "untitled_application", variable)
replace_in_file("./config/environments/production.rb", "Untitled-Application", http_header_style)
replace_in_file("./config/environments/test.rb", "Untitled-Application", http_header_style)
replace_in_file("./config/environments/development.rb", "Untitled-Application", http_header_style)
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
Dir.glob("./bin/docker-dev/*").each do |file|
  replace_in_file(file, "untitled_application", variable)
end

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
