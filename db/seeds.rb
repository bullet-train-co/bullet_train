# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# TODO Allow this message to be printed once we figure out the DatabaseCleaner issue.
# puts "🌱 Generating global seeds." unless Rails.env.test?
load "#{Rails.root}/db/seeds/webhooks.rb"

# Ensure the admin role is in the database.
Role.admin

load "#{Rails.root}/db/seeds/development.rb" if Rails.env.development?
load "#{Rails.root}/db/seeds/test.rb" if Rails.env.test?
