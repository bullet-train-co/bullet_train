puts "🌱 Generating test environment seeds."

# We use this stub to test `seeding?` for ActiveRecord models.
if ENV["seed_stub"] == "true"
  User.create(email: "test@test.com", password: "956742469855eba772ea62b9f14d8626")
  user = User.find_by(email: "test@test.com")
  p "User is seeding: #{user.seeding?}"
end
