# These are not combined because we want to reload all models after the migrations take place.
release: bundle exec rails db:migrate; bundle exec rails db:seed
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -t 25
