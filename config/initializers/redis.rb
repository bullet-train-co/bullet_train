if heroku?
  $redis = Redis.new(url: ENV["REDIS_URL"], ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}) # standard:disable Style/GlobalVars
end
