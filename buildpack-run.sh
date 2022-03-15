echo "㊙️ Running Buildpack."

bundle exec rake bt:link

yarn build
yarn light:build
yarn light:build:css

# TODO Get the stuff above running as part of `rake assets:precompile`.
rake assets:precompile

echo "㊙️ Running Buildpack."
