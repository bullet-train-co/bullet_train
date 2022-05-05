#!/usr/bin/env bash
# exit on error
set -o errexit

gem install bundler -v 2.3.8
bundler _2.3.8_ -v

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
