#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean

# These are not combined because we want to reload all models after the migrations take place.
# TODO Any way to read these from the `Procfile` where we have the same thing defined for Heroku?
bundle exec rails db:migrate 
bundle exec rails db:seed
