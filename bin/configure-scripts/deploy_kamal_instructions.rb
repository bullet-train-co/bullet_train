#!/usr/bin/env ruby

require "#{__dir__}/utils"

announce_section "Add 'Deploy to Kamal' instructions?"

instructions_file = "#{__dir__}/deploy-instructions/kamal.md"

add_instructions = ask_boolean "Would you like to add Kamal deploy instructions to your project.", "y"
if add_instructions
  File.open("README.md", "a") do |readme|
    instruction = File.read(instructions_file)
    instruction.each_line do |line|
      readme << line
    end
  end
else
  puts "Not adding 'Deploy to Kamal' instructions.".yellow
end
