if ENV["REDIS_URL"].present?
  # from https://devcenter.heroku.com/articles/heroku-redis#connecting-in-rails
  $redis = Redis.new(url: ENV["REDIS_URL"], ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
end
