puts "㊙️ Running Buildpack."

bundle exec rake bt:link

yarn build
yarn light:build
yarn light:build:css

puts "㊙️ Running Buildpack."
