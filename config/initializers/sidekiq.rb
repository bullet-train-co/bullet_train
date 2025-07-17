if heroku?
  Sidekiq.configure_server do |config|
    config.redis = {ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}}
  end

  Sidekiq.configure_client do |config|
    config.redis = {ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}}
  end
elsif ENV["KAMAL_SETUP"] == "true"
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV.fetch("REDIS_URL") { "redis://:#{ENV["REDIS_PASSWORD"]}@#{ENV["REDIS_HOST"]}:#{ENV["REDIS_PORT"]}" }
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: ENV.fetch("REDIS_URL") { "redis://:#{ENV["REDIS_PASSWORD"]}@#{ENV["REDIS_HOST"]}:#{ENV["REDIS_PORT"]}" }
    }
  end
end
