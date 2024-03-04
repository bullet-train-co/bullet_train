puts "🌱 Generating development environment seeds."

puts "Creating the PROVE Team"

prove = Team.find_or_create_by(name: "PROVE") do |team|
  puts "Creating the PROVE Team"
end

puts "Creating some users"
User.find_or_create_by(email: "adam@test.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.first_name = "Adam"
  user.last_name = "Test"
  prove.users << user
  user.memberships.first.roles << Role.admin
end
User.find_or_creat_by(email: "paul@proveng.com.au") do |user|
  user.password = "password"
  user.password_confirmation = "password"
  user.first_name = "Paul"
  user.last_name = "Oliveri"
  prove.users << user
  user.memberships.first.roles << Role.admin
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
