# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# TODO: Is this the best place for this?
if ENV['SPROCKETS_NO_EXPORT_CONCURRENT']
  # Prevent timeouts
  Regexp.timeout = 60 * 5

  puts "********************************************************************************"
  puts "We are setting Sprockets.export_concurrent = false"
  puts "Regexp.timeout = #{Regexp.timeout}"
  puts "********************************************************************************"
  # This prevents asset precompilation from hanging indefinitely.
  # https://github.com/rails/sprockets/issues/640
  Sprockets.export_concurrent = false

  # https://github.com/capistrano/rails/issues/55
  Rails.application.config.assets.logger = Logger.new $stdout
else
  puts "********************************************************************************"
  puts "We are NOOOOOT setting Sprockets.export_concurrent = false"
  puts "********************************************************************************"
end
