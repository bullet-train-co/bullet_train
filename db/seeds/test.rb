puts "🌱 Generating test environment seeds." if Rails.env.test?

# We only use this role in one of the tests.
Role.find_or_create_by(key: :another_role_key) do |role|
  role.display_order = 1
end
