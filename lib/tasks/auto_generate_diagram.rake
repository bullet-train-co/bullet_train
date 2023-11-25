# frozen_string_literal: true

# TODO: This is a temporary fix so that rails-erd picks up all of our models.
# https://github.com/voormedia/rails-erd/issues/322
if Rails.env.development?
  RailsERD.load_tasks
  Rake::Task["erd:load_models"].clear

  namespace :erd do
    task :load_models do
      puts "Loading application environment..."
      Rake::Task[:environment].invoke

      puts "Loading code in search of Active Record models..."
      Zeitwerk::Loader.eager_load_all
    end
  end
end
