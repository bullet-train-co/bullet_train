puts "🌱 Generating development environment seeds."

puts "Creating the PROVE Team"

prove = Team.find_or_create_by(name: "PROVE") do |team|
  puts "Creating the PROVE Team"
end

puts "Creating some users"
adam = User.find_or_create_by(email: "adam@test.com") do |user|
  user.email = "adam@test.com"
  user.password = "password"
  user.password_confirmation = "password"
  user.first_name = "Adam"
  user.last_name = "Test"
end

paul = User.find_or_create_by(email: "paul@proveng.com.au") do |user|
  user.email = "paul@proveeng.com.au"
  user.password = "password"
  user.password_confirmation = "password"
  user.first_name = "Paul"
  user.last_name = "Oliveri"
  puts "Adding user #{user.email} to the PROVE team"
end

begin
  membership = prove.memberships.create(user: adam, user_email: adam.email)
  membership.roles << Role.admin
rescue ActiveRecord::RecordInvalid
  puts "User #{adam.email} already exists"
end


begin
  membership = prove.memberships.create(user: paul, user_email: paul.email)
  membership.roles << Role.admin
rescue ActiveRecord::RecordInvalid
  puts "User #{paul.email} already exists"
end

puts "Creating the departments"
Department.find_or_create_by(name: "Infrastructure") do |department|
  department.team = prove
end

puts "Creating some jobs"
Job.find_or_create_by(name: "Job 1") do |job|
  job.department = Department.first
  job.team = prove
end
