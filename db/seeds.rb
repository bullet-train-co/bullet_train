# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# 👋 Also, seeds in Bullet Train are slightly different than vanilla Rails.
# See `docs/seeds.md` for details.

puts "🌱 Generating global seeds."

Application.find_or_create_by(id: 1)

load "#{Rails.root}/db/seeds/development.rb" if Rails.env.development?

# We use this stub to test `seeding?` for ActiveRecord models.
if Rails.env == "test" && ENV["seed_stub"] == "true"
  User.create(email: "test@test.com", password: "956742469855eba772ea62b9f14d8626")
  user = User.find_by(email: "test@test.com")
  p "User is seeding: #{user.seeding?}"
end
