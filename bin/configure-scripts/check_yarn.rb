#!/usr/bin/env ruby

require "#{__dir__}/utils"
if `yarn -v 2> /dev/null`.length > 0
  puts "Yarn is installed.".green
else
  puts "You don't have Yarn installed. We probably can't proceed with out it. Try `brew install yarn` or see the installation instructions at https://yarnpkg.com/getting-started/install .".red

  continue_anyway = ask_boolean "Try proceeding without `yarn`?", "y"
  if continue_anyway
    puts "You have chosen to continue without `yarn`.".yellow
  else
    puts "You have chosen not to continue without `yarn`. Goodbye".red
    exit
  end
end
